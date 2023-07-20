import 'package:flutter/material.dart';

class ConversationCard extends StatefulWidget {
  const ConversationCard({Key? key}) : super(key: key);

  @override
  State<ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        title: Text('First Card'),
        trailing: Icon(Icons.delete, color: Colors.red,),
      ),
    );
  }
}
