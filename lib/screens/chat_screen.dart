import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 33, 35, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  Color.fromRGBO(32, 33, 35, 1),
        title: Text(
          'Talk with ChatGPT',
          style: TextStyle(
            color: Colors.white,
          )
        )
      ),
      body: Column(
        children: [
          Expanded(flex:8, child: Text("HI")),
          Expanded(flex: 1, child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left:12, right:12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      print("voice recording started");
                    },
                    child: Icon(Icons.keyboard_voice, color: Colors.white),),
                  SizedBox(width: 18,),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        print(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Send a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 18,),
                  GestureDetector(
                    onTap: () {
                      print("sent");
                    },
                    child: Icon(Icons.send, color:Colors.white),)
                ],
              ),
            )
          ))
        ],
      )
    );
  }
}
