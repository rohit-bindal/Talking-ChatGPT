import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String sender;
  const MessageBubble({Key? key, required this.message, required this.sender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: sender=='Chat GPT' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(sender, style: TextStyle(
            color: Colors.white70,
            fontSize: 12.0
          ),),
          Material(
            color: sender=='You' ? Color.fromRGBO(52, 53, 65, 1) : Color.fromRGBO(68, 70, 84, 1),
            borderRadius: sender == 'Chat GPT' ? BorderRadius.only(topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)) : BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: TextStyle(

                  color: Colors.white,
                  fontSize: 15
                ),
              )
            )
          )
        ],
      ),
    );
  }
}
