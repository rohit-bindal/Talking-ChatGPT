import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/message_bubble.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool showSpinner = false;
  StreamSubscription<QuerySnapshot>? _streamSubscription;
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String message = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)?.settings?.arguments as Map<String,String>;
    _streamSubscription =_firestore.collection((loggedInUser?.email).toString()).doc('convo').collection(args['conversationName'].toString()).snapshots().listen((event) {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null) loggedInUser = user;
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings?.arguments as Map<String,String>;
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 33, 35, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  Color.fromRGBO(32, 33, 35, 1),
        title: Text(
          '${args['conversationName']}',
          style: TextStyle(
            color: Colors.white,
          )
        )
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            Expanded(flex:8, child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection((loggedInUser?.email).toString()).doc('convo').collection(args['conversationName'].toString()).orderBy('Timestamp').snapshots(),
                builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      );
                    }
                    List<MessageBubble> messageBubbles = [];
                      final messages = snapshot.data!.docs.reversed;
                      for (var message in messages!) {
                        final sender = (message.data() as dynamic)['sender'];
                        final text = (message.data() as dynamic)['message'];
                        messageBubbles.add(
                            MessageBubble(message: text, sender: sender));
                      }
                    return ListView(
                      reverse: true,
                      children: messageBubbles,
                    );
                  }
              )
            )),
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
                        controller: messageTextController,
                        onChanged: (value) {
                          message=value;
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
                      onTap: () async {
                        messageTextController.clear();
                          await _firestore.collection((loggedInUser?.email).toString()).doc('convo').
                        collection(args['conversationName'].toString()).add(
                            {
                              'sender': 'Chat GPT',
                              'message': message,
                              'Timestamp': FieldValue.serverTimestamp(),
                            }
                          );
                      },
                      child: Icon(Icons.send, color:Colors.white),)
                  ],
                ),
              )
            ))
          ],
        ),
      )
    );
  }
}
