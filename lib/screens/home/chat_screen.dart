import 'package:flutter/material.dart';
import 'call_screen.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  final String lawyerName;
  final String lawyerImage;
  final bool viewerIsLawyer;

  const ChatScreen({
    Key? key,
    required this.lawyerName,
    required this.lawyerImage,
    required this.viewerIsLawyer,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Add realistic conversation messages
    _messages.add(
      ChatMessage(
        text: "Please i just got arrested for murder, something i dont know anything about. The police are asking me to tell the truth. Something i dont know anything about.",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    );
    _messages.add(
      ChatMessage(
        text: "Hello there .",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    );
    _messages.add(
      ChatMessage(
        text: "Greetings it shall be great to help you with your problem and to solve the same.",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
    );
    _messages.add(
      ChatMessage(
        text: "Hey hi",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    );
    _messages.add(
      ChatMessage(
        text: "Sure i shall start from the beginning and share all the documents. Do help me to solve my case.",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          // If viewer is a lawyer, their messages are not from the user
          isUser: widget.viewerIsLawyer ? false : true,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Simulate lawyer response after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "Thank you for your message. I'll review your case and get back to you shortly.",
              // Simulated reply comes from the other party
              isUser: widget.viewerIsLawyer ? true : false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.lawyerImage),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Text(
              widget.lawyerName,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          // In-app calling temporarily disabled
          // IconButton(
          //   icon: const Icon(Icons.call, color: Colors.black),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CallScreen(
          //           lawyerName: widget.lawyerName,
          //           lawyerImage: widget.lawyerImage,
          //         ),
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Implement more options functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) {
                return _buildMessageItem(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    // Determine if this message was sent by the current viewer
    final bool isFromViewer = widget.viewerIsLawyer
        ? !message.isUser // viewer is lawyer -> lawyer messages are not 'user'
        : message.isUser; // viewer is user -> user messages are 'user'

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            isFromViewer ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show avatar for the other party only
          if (!isFromViewer) ...[  
            CircleAvatar(
              backgroundImage: AssetImage(widget.lawyerImage),
              radius: 16,
            ),
            const SizedBox(width: 6.0),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isFromViewer ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isFromViewer ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (isFromViewer) const SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _handleAttachment,
            ),
            Flexible(
              child: TextField(
                controller: _messageController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAttachment() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Share phone number'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final controller = TextEditingController();
                  final number = await showDialog<String>(
                    context: context,
                    builder: (dCtx) {
                      return AlertDialog(
                        title: const Text('Enter phone number'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '+1 555 123 4567',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dCtx),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(dCtx, controller.text.trim()),
                            child: const Text('Share'),
                          ),
                        ],
                      );
                    },
                  );
                  if (number != null && number.isNotEmpty) {
                    setState(() {
                      _messages.add(
                        ChatMessage(
                          text: 'Shared phone number: $number',
                          isUser: widget.viewerIsLawyer ? false : true,
                          timestamp: DateTime.now(),
                        ),
                      );
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Attach a file'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
                    final file = result?.files.first;
                    if (file != null) {
                      setState(() {
                        _messages.add(
                          ChatMessage(
                            text: 'Shared file: ${file.name}',
                            isUser: widget.viewerIsLawyer ? false : true,
                            timestamp: DateTime.now(),
                          ),
                        );
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to pick file: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}