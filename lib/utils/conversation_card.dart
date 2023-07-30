import 'package:flutter/material.dart';
import '../assets/constants.dart';

class ConversationCard extends StatefulWidget {
  final String title;
  final void Function(String) removeCard;
  final void Function(String) navigate;
  const ConversationCard(
      {Key? key,
      required this.title,
      required this.removeCard,
      required this.navigate})
      : super(key: key);

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
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.navigate(widget.title);
                    },
                    child: const Icon(
                      Icons.start,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () => widget.removeCard(widget.title),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
