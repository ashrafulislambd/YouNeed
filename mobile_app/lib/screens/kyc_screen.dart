import 'package:flutter/material.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
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
                        'Pending Submission',
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
              'Required Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildUploadCard(
              title: 'National ID / Passport',
              description: 'Scan front and back side',
              icon: Icons.badge_outlined,
              isUploaded: true,
              isDark: isDark,
              cardColor: cardColor,
              textColor: textColor,
            ),
            _buildUploadCard(
              title: 'Utility Bill',
              description: 'Recent electricity or gas bill',
              icon: Icons.receipt_long_outlined,
              isUploaded: false,
              isDark: isDark,
              cardColor: cardColor,
              textColor: textColor,
            ),
             _buildUploadCard(
              title: 'Face Verification',
              description: 'Take a clear selfie',
              icon: Icons.face_retouching_natural_outlined,
              isUploaded: false,
              isDark: isDark,
              cardColor: cardColor,
              textColor: textColor,
            ),

            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Submit Application',
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
