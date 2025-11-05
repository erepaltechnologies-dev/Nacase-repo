import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/user.dart';

class LawyerVerificationDetailScreen extends StatefulWidget {
  final User user;

  const LawyerVerificationDetailScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<LawyerVerificationDetailScreen> createState() => _LawyerVerificationDetailScreenState();
}

class _LawyerVerificationDetailScreenState extends State<LawyerVerificationDetailScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Details'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            _buildProfileSection(),
            const SizedBox(height: 24),
            
            // Personal Information
            _buildSectionCard(
              title: 'Personal Information',
              children: [
                _buildInfoRow('Full Name', widget.user.name),
                _buildInfoRow('Email', widget.user.email),
                if (widget.user.phone != null)
                  _buildInfoRow('Phone', widget.user.phone!),
                if (widget.user.bio != null)
                  _buildInfoRow('Bio', widget.user.bio!),
              ],
            ),
            const SizedBox(height: 16),
            
            // Professional Information
            _buildSectionCard(
              title: 'Professional Information',
              children: [
                if (widget.user.firmName != null)
                  _buildInfoRow('Law Firm', widget.user.firmName!),
                if (widget.user.areaOfPractice != null)
                  _buildInfoRow('Area of Practice', widget.user.areaOfPractice!),
                if (widget.user.subcategory != null)
                  _buildInfoRow('Subcategory', widget.user.subcategory!),
                if (widget.user.state != null)
                  _buildInfoRow('State', widget.user.state!),
                if (widget.user.yearOfCall != null)
                  _buildInfoRow('Year of Call', widget.user.yearOfCall.toString()),
                if (widget.user.supremeCourtNumber != null)
                  _buildInfoRow('Supreme Court Number', widget.user.supremeCourtNumber!),
                if (widget.user.linkedInUrl != null)
                  _buildInfoRow('LinkedIn Profile', widget.user.linkedInUrl!),
              ],
            ),
            const SizedBox(height: 16),
            
            // Identity Information
            if (widget.user.nin != null)
              _buildSectionCard(
                title: 'Identity Information',
                children: [
                  _buildInfoRow('NIN', widget.user.nin!),
                ],
              ),
            const SizedBox(height: 16),
            
            // Documents Section
            if (widget.user.documents != null && widget.user.documents!.isNotEmpty)
              _buildDocumentsSection(),
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              backgroundImage: widget.user.profileImageUrl != null 
                  ? NetworkImage(widget.user.profileImageUrl!) 
                  : null,
              child: widget.user.profileImageUrl == null 
                  ? Text(
                      widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'PENDING VERIFICATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uploaded Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.user.documents!.asMap().entries.map((entry) {
              final index = entry.key;
              final documentUrl = entry.value;
              return _buildDocumentItem(index + 1, documentUrl);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(int index, String documentUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: Colors.blue[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document $index',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  documentUrl,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _viewDocument(documentUrl),
            icon: const Icon(Icons.open_in_new),
            tooltip: 'View Document',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isProcessing ? null : () => _showRejectDialog(),
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text(
                  'Reject Application',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _approveApplication,
                icon: _isProcessing 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(_isProcessing ? 'Processing...' : 'Approve Application'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to List'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _viewDocument(String documentUrl) {
    // In a real app, you would implement document viewing
    // For now, show a dialog with the URL
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Document URL:'),
            const SizedBox(height: 8),
            SelectableText(
              documentUrl,
              style: TextStyle(
                color: Colors.blue[600],
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: In a production app, this would open the document viewer.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _approveApplication() async {
    setState(() => _isProcessing = true);
    
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final success = await adminProvider.approveLawyerVerification(widget.user.id);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application approved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to approve application'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showRejectDialog() {
    final reasonController = TextEditingController();
    final parentContext = context;
    
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to reject ${widget.user.name}\'s application?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for rejection *',
                border: OutlineInputBorder(),
                hintText: 'Please provide a detailed reason...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for rejection'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(dialogContext);
              if (!mounted) return;
              setState(() => _isProcessing = true);
              
              try {
                final adminProvider = Provider.of<AdminProvider>(parentContext, listen: false);
                final success = await adminProvider.rejectLawyerVerification(
                  widget.user.id,
                  reasonController.text.trim(),
                );
                
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Application rejected successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(parentContext); // Go back to list
                  } else {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to reject application'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } finally {
                if (mounted) {
                  setState(() => _isProcessing = false);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}