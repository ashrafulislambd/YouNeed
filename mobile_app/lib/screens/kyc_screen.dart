import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/kyc_service.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final KYCService _kycService = KYCService();
  final ImagePicker _picker = ImagePicker();
  
  XFile? _selectedImage;
  String _documentType = 'NID';
  final _documentNumberController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _kycStatus;

  @override
  void initState() {
    super.initState();
    _loadKYCStatus();
  }

  @override
  void dispose() {
    _documentNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadKYCStatus() async {
    setState(() => _isLoading = true);
    final result = await _kycService.getKYCStatus();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _kycStatus = result['data'];
        }
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _submitKYC() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a document image'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_documentNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter document number'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Read bytes from XFile
    final bytes = await _selectedImage!.readAsBytes();
    
    final result = await _kycService.submitKYC(
      type: _documentType,
      documentNumber: _documentNumberController.text,
      imageBytes: bytes,
      filename: _selectedImage!.name,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'KYC submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload status
        _loadKYCStatus();
        // Clear form
        setState(() {
          _selectedImage = null;
          _documentNumberController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'KYC submission failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB);
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Verification',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: textColor, size: 20),
              tooltip: 'Due Payments',
              onPressed: () => Navigator.pushNamed(context, '/due-payment'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.receipt_long_rounded, color: textColor, size: 20),
              tooltip: 'Transactions',
              onPressed: () => Navigator.pushNamed(context, '/'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.credit_card_rounded, color: textColor, size: 20),
              tooltip: 'Credit Status',
              onPressed: () => Navigator.pushNamed(context, '/credit'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.person_outline_rounded, color: textColor, size: 20),
              tooltip: 'Profile / Register',
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete your\nKYC Verification',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please submit the required documents to verify your identity.',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Status Card
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_kycStatus != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getStatusColors(_kycStatus!['status'] ?? 'PENDING', isDark),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _getStatusColor(_kycStatus!['status'] ?? 'PENDING').withOpacity(isDark ? 0.3 : 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getStatusIcon(_kycStatus!['status'] ?? 'PENDING'),
                        color: _getStatusColor(_kycStatus!['status'] ?? 'PENDING'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _kycStatus!['status'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 18,
                              color: _getStatusColor(_kycStatus!['status'] ?? 'PENDING'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_kycStatus!['clarification'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _kycStatus!['clarification'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                        ? [Colors.orange.withOpacity(0.15), Colors.orange.withOpacity(0.05)]
                        : [Colors.orange.withOpacity(0.1), Colors.orange.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.orange.withOpacity(isDark ? 0.3 : 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.pending_actions_rounded, color: Colors.orange),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'Not Submitted',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 32),
            Text(
              'Submit Document',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Document Type Selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDocumentTypeButton('NID', 'National ID', Icons.badge_outlined, isDark, cardColor, textColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDocumentTypeButton('PASSPORT', 'Passport', Icons.card_travel_outlined, isDark, cardColor, textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _documentNumberController,
                    decoration: InputDecoration(
                      labelText: 'Document Number',
                      labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black45),
                      filled: true,
                      fillColor: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white24 : Colors.grey.withOpacity(0.2),
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _selectedImage!.path,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Column(
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 48,
                            color: isDark ? Colors.white38 : Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to select document image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'JPG, PNG (Max 5MB)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitKYC,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit KYC Application',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeButton(String type, String label, IconData icon, bool isDark, Color cardColor, Color textColor) {
    final isSelected = _documentType == type;
    return GestureDetector(
      onTap: () => setState(() => _documentType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white24 : Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isDark ? Colors.black : Colors.white)
                  : textColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
      default:
        return Colors.orange;
    }
  }

  List<Color> _getStatusColors(String status, bool isDark) {
    final color = _getStatusColor(status);
    return isDark
        ? [color.withOpacity(0.15), color.withOpacity(0.05)]
        : [color.withOpacity(0.1), color.withOpacity(0.05)];
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'APPROVED':
        return Icons.check_circle_outline_rounded;
      case 'REJECTED':
        return Icons.cancel_outlined;
      case 'PENDING':
      default:
        return Icons.pending_actions_rounded;
    }
  }

  Widget _buildUploadCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isUploaded,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isUploaded 
                        ? (isDark ? const Color(0xFF1B3320) : const Color(0xFFE8F5E9))
                        : (isDark ? Colors.black12 : const Color(0xFFF5F5F5)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isUploaded ? Icons.check_circle_outline_rounded : icon,
                    color: isUploaded ? const Color(0xFF4CAF50) : (isDark ? Colors.white54 : Colors.grey[600]),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[500],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isUploaded ? cardColor : (isDark ? Colors.white : Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    border: isUploaded ? Border.all(color: isDark ? Colors.white24 : Colors.grey.withOpacity(0.2)) : null,
                  ),
                  child: Text(
                    isUploaded ? 'Edit' : 'Upload',
                    style: TextStyle(
                      color: isUploaded ? textColor : (isDark ? Colors.black : Colors.white),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
