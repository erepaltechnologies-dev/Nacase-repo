import 'package:flutter/material.dart';
import 'dart:async';

class CallScreen extends StatefulWidget {
  final String lawyerName;
  final String lawyerImage;

  const CallScreen({
    Key? key,
    required this.lawyerName,
    required this.lawyerImage,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              widget.lawyerImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top section with back button and "Call" text
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Call',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 48), // To balance the back button
                    ],
                  ),
                ),
                Spacer(),
                // Bottom section with lawyer name, duration and end call button
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Column(
                    children: [
                      // Lawyer name and duration container
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.lawyerName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    _formatDuration(_seconds),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                       // Call control buttons
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           // Speaker button
                           Container(
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: _isSpeakerOn ? Colors.white : Colors.black.withOpacity(0.5),
                             ),
                             child: IconButton(
                               icon: Icon(
                                 Icons.volume_up,
                                 color: _isSpeakerOn ? Colors.black : Colors.white,
                               ),
                               iconSize: 30,
                               onPressed: () {
                                 setState(() {
                                   _isSpeakerOn = !_isSpeakerOn;
                                 });
                               },
                             ),
                           ),
                           // End call button
                           Container(
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: Colors.red,
                             ),
                             child: IconButton(
                               icon: Icon(Icons.call_end, color: Colors.white),
                               iconSize: 40,
                               onPressed: () {
                                 Navigator.pop(context);
                               },
                             ),
                           ),
                           // Mute button
                           Container(
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: Colors.black.withOpacity(0.5),
                             ),
                             child: IconButton(
                               icon: Icon(Icons.mic_off, color: Colors.white),
                               iconSize: 30,
                               onPressed: () {
                                 // Toggle mute functionality
                               },
                             ),
                           ),
                         ],
                       ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}