import 'package:flutter/material.dart';
import 'package:talking_chatgpt/screens/user_screen.dart';
import '../screens/chat_screen.dart';

class ConversationCard extends StatefulWidget {
  final String title;
  final int id;
  final void Function(int) removeCard;
  final void Function(String) navigate;
  const ConversationCard({Key? key, required this.title, required this.removeCard, required this.id, required this.navigate}) : super(key: key);

  @override
  State<ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(52, 53, 65, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(widget.title, style: TextStyle(color: Colors.white),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(onTap: (){
                  widget.navigate(widget.title);
                },
                    child: Icon(Icons.start, color: Colors.green,),),
                SizedBox(width: 12,),
                GestureDetector(
                  onTap: () => widget.removeCard(widget.id),
                  child: Icon(Icons.delete, color: Colors.red,),)
              ],
            )
          ),
        ),
      ),
    );
  }
}
