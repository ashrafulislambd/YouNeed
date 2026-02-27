import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRPaymentPage extends StatefulWidget {
  @override
  _QRPaymentPageState createState() => _QRPaymentPageState();
}

class _QRPaymentPageState extends State<QRPaymentPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = '';
  bool isScanning = true;
  double paymentAmount = 0.0;
  String merchantName = '';

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required for QR scanning')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        setState(() {
          scannedData = scanData.code!;
          isScanning = false;
          _parseQRData(scannedData);
        });
      }
    });
  }

  void _parseQRData(String data) {
    // Parse QR data - assuming format: merchant:name:amount
    try {
      final parts = data.split(':');
      if (parts.length >= 3) {
        merchantName = parts[1];
        paymentAmount = double.tryParse(parts[2]) ?? 0.0;
      }
    } catch (e) {
      merchantName = 'Unknown Merchant';
    }
  }

  void _resumeScanning() {
    setState(() {
      isScanning = true;
      scannedData = '';
      merchantName = '';
      paymentAmount = 0.0;
    });
    controller?.resumeCamera();
  }

  void _processPayment() {
    // Here you would integrate with your payment API
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text('Payment of \$${paymentAmount.toStringAsFixed(2)}'),
            Text('to $merchantName was successful!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resumeScanning();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Payment'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          // QR Scanner Section
          Expanded(
            flex: 2,
            child: isScanning
                ? QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.blue,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 250,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner, size: 80, color: Colors.green),
                        SizedBox(height: 20),
                        Text('QR Code Scanned!', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
          ),

          // Payment Details Section
          if (!isScanning && scannedData.isNotEmpty)
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[50],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Payment Details', style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Merchant:', style: TextStyle(color: Colors.grey[600])),
                        Text(merchantName, style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount:', style: TextStyle(color: Colors.grey[600])),
                        Text('\$${paymentAmount.toStringAsFixed(2)}', style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        )),
                      ],
                    ),
                    
                    SizedBox(height: 10),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _resumeScanning,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(width: 8),
                              Text('Scan Again'),
                            ],
                          ),
                        ),
                        
                        ElevatedButton(
                          onPressed: _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.payment),
                              SizedBox(width: 8),
                              Text('Pay Now'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Instructions Section (when scanning)
          if (isScanning)
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How to Pay:', style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                    SizedBox(height: 15),
                    _buildInstruction(Icons.qr_code, '1. Scan merchant QR code'),
                    _buildInstruction(Icons.visibility, '2. Verify payment details'),
                    _buildInstruction(Icons.credit_card, '3. Confirm payment'),
                    _buildInstruction(Icons.check_circle, '4. Instant confirmation'),
                    
                    SizedBox(height: 20),
                    Text(
                      'Scan QR code within the frame above',
                      style: TextStyle(color: Colors.blue[800]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}