import 'package:flutter/material.dart';
import '../assets/constants.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  final bool isImage;
  const MessageBubble(
      {Key? key,
      required this.message,
      required this.sender,
      required this.isImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sender == 'assistant'
          ? const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 80)
          : const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 80),
      child: Column(
        crossAxisAlignment: sender == 'assistant'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            sender == 'assistant' ? 'ChatGPT' : 'You',
            style: const TextStyle(color: Colors.white70, fontSize: 12.0),
          ),
          Material(
              color: sender == 'user'
                  ? backgroundColor
                  : const Color.fromRGBO(68, 70, 84, 1),
              borderRadius: sender == 'assistant'
                  ? const BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
              elevation: 5.0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: isImage == false
                      ? Text(
                          message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        )
                      : Image(image: NetworkImage(message))))
        ],
      ),
    );
  }
}
