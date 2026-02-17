import 'package:flutter/material.dart';
import 'donation_model.dart';

class CreateDonationScreen extends StatefulWidget {
  const CreateDonationScreen({Key? key}) : super(key: key);

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _storyController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationController = TextEditingController();
  final _relationshipController = TextEditingController(); // Optional: e.g. "Myself" or "Neighbor"
  
  // Dynamic list for specific persons (Max 3)
  final List<TextEditingController> _personControllers = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Start with one field
    _personControllers.add(TextEditingController());
  }

  void _addPersonField() {
    if (_personControllers.length < 3) {
      setState(() {
        _personControllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can request from up to 3 people only.')),
      );
    }
  }

  void _removePersonField(int index) {
    setState(() {
      _personControllers[index].dispose();
      _personControllers.removeAt(index);
    });
  }

  void _submitDonationRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 1));

      // Filter out empty names
      final specificPersons = _personControllers
          .map((c) => c.text.trim())
          .where((name) => name.isNotEmpty)
          .toList();

      final newCase = DonationCase(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        story: _storyController.text,
        targetAmount: double.parse(_amountController.text),
        currentAmount: 0,
        location: _locationController.text.isNotEmpty ? _locationController.text : 'Unknown',
        relationship: _relationshipController.text.isNotEmpty ? _relationshipController.text : 'Community Member',
        isFromContacts: true, // Assuming user requests are from "contacts" or verified users
        hasHelpPost: true,
        requestedFrom: specificPersons,
        imageUrl: '',
      );

      DonationService().addCase(newCase);

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donation request submitted successfully!')),
        );
        Navigator.pop(context); // Go back to dashboard
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _storyController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _relationshipController.dispose();
    for (var controller in _personControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Money'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a Request',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ask for financial support from specific people or the community.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _nameController,
                label: 'Title / Your Name',
                icon: Icons.title,
                validator: (value) => value!.isEmpty ? 'Please enter a title or name' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _storyController,
                label: 'Reason / Story',
                icon: Icons.description,
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Please enter the reason' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                   Expanded(
                    child: _buildTextField(
                      controller: _amountController,
                      label: 'Amount Needed (৳)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                         if (value == null || value.isEmpty) return 'Enter amount';
                         if (double.tryParse(value) == null) return 'Invalid amount';
                         return null;
                      },
                    ),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                    child: _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      icon: Icons.location_on,
                    ),
                   ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _relationshipController,
                label: 'Relationship (Optional)',
                icon: Icons.people,
              ),
              
              const SizedBox(height: 24),
              Text(
                'Request from Specific People (Max 3)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              
              ...List.generate(_personControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _personControllers[index],
                          label: 'Person Name / ID ${index + 1}',
                          icon: Icons.person,
                          hint: 'Enter name of person to ask',
                        ),
                      ),
                      if (index > 0) // Allow removing additional fields, keep at least one (which can be empty)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _removePersonField(index),
                        ),
                    ],
                  ),
                );
              }),

              if (_personControllers.length < 3)
                TextButton.icon(
                  onPressed: _addPersonField,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Another Person'),
                ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitDonationRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                   child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Request',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
        prefixIcon: Icon(icon, color: isDark ? Colors.white54 : Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
