import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/message_bubble.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:talking_chatgpt/services/openai/gpt-3.5-turbo.dart';
import 'package:talking_chatgpt/services/openai/dall-e.dart';
import '../assets/constants.dart';
import '../services/firebase/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool showSpinner = false;
  StreamSubscription<QuerySnapshot>? _streamSubscription;
  final messageTextController = TextEditingController();
  String message = '';
  FlutterTts flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  String lastWords = '';
  Color recordingIconColor = Colors.white;
  Color sendIconColor = Colors.white;
  List<Map<String, String>> conversations = [];
  User? loggedInUser;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final GPTService gptService = GPTService();
  final DALLEService dalleService = DALLEService();
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  final _firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)?.settings.arguments as Map<String,String>;
    _streamSubscription = _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').doc(args['conversationName'].toString()).collection('messages').snapshots().listen((event) {
      setState(() {
      });
    });
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
    Future.delayed(Duration.zero, () async {
      loggedInUser = await firebaseAuth.getCurrentUser();
    });
    initSpeech();
    Future.delayed(Duration.zero, () async {
      var args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
      Query<Map<String, dynamic>> collectionRef =  await _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').doc(args?['conversationName'].toString()).collection('messages').orderBy('Timestamp');
      try {
        QuerySnapshot querySnapshot = await collectionRef.get();
        querySnapshot.docs.forEach((doc) {
          if (doc.data() != null) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            conversations.add({
              'role': data['sender'],
              'content': data['message']
            });
          }});
        print(conversations);
      } catch (e) {
        print("Error fetching data: $e");
      }
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map<String,String>;
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: foregroundColor,
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pushNamed(context, 'user_screen');
            },
          ),
          elevation: 0,
          backgroundColor:  foregroundColor,
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
                  stream:  _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').doc(args['conversationName'].toString()).collection('messages').orderBy('Timestamp').snapshots(),
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
                        for (var message in messages) {
                          final sender = (message.data() as dynamic)['sender'];
                          final text = (message.data() as dynamic)['message'];
                          final isImage = (message.data() as dynamic)['isImage'];
                          messageBubbles.add(
                              MessageBubble(message: text, sender: sender, isImage: isImage ?? false));
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
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if(await speechToText.hasPermission && speechToText.isNotListening){
                              setState(() {
                                recordingIconColor = Colors.red;
                              });
                              speechToText.listen(onResult: (result){
                                setState(() {
                                  lastWords=result.recognizedWords;
                                  messageTextController.text = lastWords;
                                });
                              });
                            }
                            else if(speechToText.isListening){
                              speechToText.stop();
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
                              if(message.isEmpty){
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  SnackBar(
                                    content: Text('something went wrong!',
                                      style: TextStyle(
                                          color: Colors.red
                                      ),),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            else {
                                await _firestore.collection('users').doc(
                                    (loggedInUser?.email).toString()).collection(
                                    'conversations').doc(
                                    args['conversationName'].toString()).
                                collection('messages').add(
                                    {
                                      'sender': 'You',
                                      'message': message,
                                      'isImage': false,
                                      'Timestamp': FieldValue.serverTimestamp(),
                                    }
                                );
                              setState(() {
                                sendIconColor = Colors.white;
                                conversations.add({
                                  'role': 'user',
                                  'content': message
                                });
                              });
                              String generateImage = await gptService.getResponse(
                                  [
                                    {
                                      'role': 'user',
                                      'content': 'Does the message "$message" is asking to generate an image or an art or something similar? Simply reply me either yes or no'
                                    }
                                  ]
                              );
                              if (generateImage.toLowerCase().contains('yes')) {
                                String url = await dalleService.getResponse(message);
                                await _firestore.collection('users').doc(
                                    (loggedInUser?.email).toString()).collection(
                                    'conversations').doc(
                                    args['conversationName'].toString()).
                                collection('messages').add(
                                    {
                                      'sender': 'assistant',
                                      'message': url,
                                      'isImage': true,
                                      'Timestamp': FieldValue.serverTimestamp(),
                                    }
                                );
                                setState(() {
                                  conversations.add({
                                    'role': 'assistant',
                                    'content': url
                                  });
                                });
                              }
                              else {
                                message = await gptService.getResponse(conversations);
                                await _firestore.collection('users').doc(
                                    (loggedInUser?.email).toString()).collection(
                                    'conversations').doc(
                                    args['conversationName'].toString()).
                                collection('messages').add(
                                    {
                                      'sender': 'assistant',
                                      'message': message,
                                      'isImage': false,
                                      'Timestamp': FieldValue.serverTimestamp(),
                                    }
                                );
                                  await systemSpeak(message);
                                  setState(() {
                                    conversations.add({
                                      'role': 'assistant',
                                      'content': message
                                    });
                                  });
                                  print(conversations);
                              }
                            }
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
                  ),
                )
              ))
            ],
          ),
        )
      ),
    );
  }
}
