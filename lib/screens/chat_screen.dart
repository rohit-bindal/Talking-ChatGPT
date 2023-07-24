import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/message_bubble.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

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
  FlutterTts flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  String lastWords = '';
  Color recordingIconColor = Colors.white;
  Color sendIconColor = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)?.settings?.arguments as Map<String,String>;
    _streamSubscription =_firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').doc(args['conversationName'].toString()).collection('messages').snapshots().listen((event) {
      setState(() {
      });
    });
  }

  Future<String> getResponse(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content": prompt
              }
            ]
          })
      );

      if(res.statusCode == 200){
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim(); //sanitization
        return content;
      }
    }
    catch (e) {
      return e.toString();
    }
    return '';
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
    speechToText.stop();
  }

  void initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    initSpeech();
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


  void startListening() async {
    await speechToText.listen(onResult: (result){
      setState(() {
        lastWords = result.recognizedWords;
        messageTextController.text = lastWords;
      });
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }


  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings?.arguments as Map<String,String>;
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 33, 35, 1),
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pushNamed(context, 'user_screen');
          },
        ),
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
                stream: _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').doc(args['conversationName'].toString()).collection('messages').orderBy('Timestamp').snapshots(),
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
                      onTap: () async {
                        if(await speechToText.hasPermission && speechToText.isNotListening){
                          setState(() {
                            recordingIconColor = Colors.red;
                          });
                          startListening();
                        }
                        else if(speechToText.isListening){
                          stopListening();
                          setState(() {
                            recordingIconColor = Colors.white;
                          });
                        }
                        else{
                          initSpeech();
                        }
                      },
                      child: Icon(Icons.keyboard_voice, color: recordingIconColor),),
                    SizedBox(width: 18,),
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
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
                        if(!messageTextController.text.isEmpty) {
                          setState(() {
                            message = messageTextController.text;
                            sendIconColor = Colors.green;
                          });
                          messageTextController.clear();
                          await _firestore.collection('users').doc(
                              (loggedInUser?.email).toString()).collection(
                              'conversations').doc(
                              args['conversationName'].toString()).
                          collection('messages').add(
                              {
                                'sender': 'You',
                                'message': message,
                                'Timestamp': FieldValue.serverTimestamp(),
                              }
                          );
                          setState(() {
                            sendIconColor = Colors.white;
                          });
                          await systemSpeak(message);
                        }
                        else{
                          setState(() {
                            sendIconColor = Colors.red;
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              sendIconColor = Colors.white;
                            });
                          });
                        }
                      },
                      child: Icon(Icons.send, color:sendIconColor),)
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
