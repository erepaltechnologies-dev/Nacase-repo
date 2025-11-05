import 'package:flutter/material.dart';
import '/screens/home/chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(
      senderName: 'Rako Christian.',
      messagePreview: 'Sure i shall start from the beginning and share all the documents. Do...',
      time: '10:02 AM',
      unreadCount: 1,
      senderImage: 'images/law1.jpeg',
    ),
    Message(
      senderName: 'Mike Adenuga.',
      messagePreview: 'Have my number i will be with you shorty..',
      time: '10:02 AM',
      unreadCount: 6,
      senderImage: 'images/law2.jpeg',
    ),
    Message(
      senderName: 'Lex Imperator.',
      messagePreview: 'Sure i shall start from the beginning and share all the documents. Do...',
      time: '10:02 AM',
      unreadCount: 1,
      senderImage: 'images/law3.jpeg',
    ),
    Message(
      senderName: 'Bayo Micheal.',
      messagePreview: 'Have my number i will be with you shorty..',
      time: '10:02 AM',
      unreadCount: 1,
      senderImage: 'images/law4.jpeg',
    ),
    Message(
      senderName: 'Samuel John.',
      messagePreview: 'Sure i shall start from the beginning and share all the documents. Do...',
      time: '10:02 AM',
      unreadCount: 1,
      senderImage: 'images/law5.jpeg',
    ),
    Message(
      senderName: 'Opeyemi Adeyemi.',
      messagePreview: 'Have my number i will be with you shorty..',
      time: '10:02 AM',
      unreadCount: 1,
      senderImage: 'images/law6.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          lawyerName: message.senderName,
                          lawyerImage: message.senderImage,
                          viewerIsLawyer: false,
                        ),
                      ),
                    );
                  },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(message.senderImage),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.senderName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message.messagePreview,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            
                            maxLines: 1, //maximum lines of text
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (message.unreadCount > 0) ...[
                           const SizedBox(height: 8),
                           Container(
                             padding: const EdgeInsets.symmetric(
                               horizontal: 8,
                               vertical: 4,
                             ),
                             decoration: BoxDecoration(
                               color: Colors.green,
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Text(
                               message.unreadCount.toString(),
                               style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ]
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Message {
  final String senderName;
  final String messagePreview;
  final String time;
  final int unreadCount;
  final String senderImage;

  Message({
    required this.senderName,
    required this.messagePreview,
    required this.time,
    required this.unreadCount,
    required this.senderImage,
  });
}