import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '/providers/theme_provider.dart';
import '/providers/user_profile_provider.dart';
import '/widgets/profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final bool isLawyer;
  const ProfileSettingsScreen({Key? key, this.isLawyer = false}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '08000000000');
  final _bioController = TextEditingController(text: 'Legal enthusiast using Nacase for quick advice.');

  @override
  void initState() {
    super.initState();
    // Initialize controllers with provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProfileProvider>();
      _nameController.text = userProvider.userName;
      _emailController.text = userProvider.userEmail;
      _phoneController.text = userProvider.userPhone;
      _bioController.text = userProvider.userBio;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userProvider = context.read<UserProfileProvider>();
      
      final success = await userProvider.saveProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        notifications: userProvider.notificationsEnabled,
      );
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile settings saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                    ProfileAvatar(
                      radius: 44,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white, size: 18),
                        onPressed: _pickProfilePhoto,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              _buildSectionTitle('Personal Info'),
              SizedBox(height: 12),
              _buildTextField('Full Name', _nameController, validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null),
              SizedBox(height: 12),
              _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress, enabled: false, validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter your email';
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
                return null;
              }),
              SizedBox(height: 12),
              _buildTextField(
                'Phone', 
                _phoneController, 
                keyboardType: TextInputType.phone, 
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Enter your phone number';
                  }
                  if (v.trim().length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  if (v.trim().length > 11) {
                    return 'Phone number cannot exceed 11 digits';
                  }
                  return null;
                }
              ),
              SizedBox(height: 12),
              if (widget.isLawyer) _buildMultilineField('Bio', _bioController),

              SizedBox(height: 24),
              _buildSectionTitle('Preferences'),
              SizedBox(height: 8),
              _buildSwitchTile('Push Notifications', userProvider.notificationsEnabled, (v) => userProvider.updateNotifications(v)),
              _buildSwitchTile('Dark Mode', themeProvider.isDark, (v) => themeProvider.setDark(v)),

              SizedBox(height: 24),
              _buildSectionTitle('Security'),
              SizedBox(height: 8),
              _buildOutlinedButton('Change Password', Icons.lock, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Change password coming soon')),
                );
              }),

              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: userProvider.isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: userProvider.isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Saving...', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        )
                      : Text('Save Changes', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
      final file = result?.files.first;
      if (file != null && file.bytes != null) {
        final userProvider = context.read<UserProfileProvider>();
        userProvider.updateProfileImage(file.bytes);
        // No immediate success message - user will see success when they save
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not pick image: $e')),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, String? Function(String?)? validator, bool enabled = true, List<TextInputFormatter>? inputFormatters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black54)),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.grey[100] : Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildMultilineField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black54)),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black54),
      label: Text(label, style: TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}