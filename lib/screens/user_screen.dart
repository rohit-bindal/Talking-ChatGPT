import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../utils/conversation_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../assets/constants.dart';
import '../services/firebase/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  String conversationName = 'Talk with ChatGPT';
  String email = '';
  String password = '';
  bool showSpinner = false;
  List<ConversationCard> conversations = [];
  bool showConversations = false;
  int id = 0;
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String duplicateTitle='';
  StreamSubscription<QuerySnapshot>? _streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      loggedInUser = await firebaseAuth.getCurrentUser();
    });
    _streamSubscription = _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').orderBy('timestamp').snapshots().listen((event) {
      setState(() {
      });
    });
  }

  void removeCard(String title) async {
    try{
      setState(() {
        showSpinner=true;
      });
      final collectionRef = _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations');
      final subCollectionRef = collectionRef.doc(title).collection('messages');
      final subCollectionSnapshot = await subCollectionRef.get();
      for (final doc in subCollectionSnapshot.docs) {
        await doc.reference.delete();
      }
      await subCollectionRef.parent!.delete();

      setState(() {
        showSpinner=false;
      });
    }
    catch (e) {
      setState(() {
        showSpinner=false;
      });
    }
  }

  void navigateToChatScreen(String title){
    Navigator.pushNamed(context, 'chat_screen', arguments: {'conversationName': title});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
              child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height
                  ),
                  color: backgroundColor,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image(
                                        width: 35,
                                        color: Colors.white,
                                        image: AssetImage('lib/assets/images/white_chatgpt_logo.png')
                                      ),
                                      Text(
                                      'Conversations',
                                      style: TextStyle(
                                          fontSize: 31,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                      GestureDetector(
                                        onTap: () {
                                          firebaseAuth.signOut();
                                          Navigator.pushNamed(context, 'login_screen');
                                        },
                                        child: Icon(
                                          Icons.logout,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ]
                            )),
                        Expanded(
                          flex: 8,
                          child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: foregroundColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(55),
                                      topRight: Radius.circular(55)
                                  )
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _firestore.collection('users').doc((loggedInUser?.email).toString()).collection('conversations').orderBy('timestamp').snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                          )
                                      );
                                    }
                                    final titles = snapshot.data!.docs;
                                    conversations.clear();
                                    id=0;
                                    for (var title in titles!) {
                                      conversations.add(
                                          ConversationCard(title: (title.data() as dynamic)['title'].toString(), removeCard: removeCard, navigate: navigateToChatScreen)
                                      );
                                      id++;
                                    }
                                    return conversations.length==0 ? Center(
                                      child: Text(
                                        "You don't have any conversation",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300
                                        ),
                                      )
                                    ) : Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 25, top: 75, bottom: 25),
                                      child: ListView(
                                        children: conversations,
                                      ),
                                    );

                                  }
                              )
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                duplicateTitle='';
                              });
                              showDialog(context: context, builder: (context){
                                return Container(
                                  child: StatefulBuilder(
                                    builder: (context, setState){
                                    return AlertDialog(
                                      backgroundColor: foregroundColor,
                                      title: Text('Conversation Name', style: TextStyle(color: Colors.white),),
                                      content: TextField(
                                        maxLength: 30,
                                        style: TextStyle(color: Colors.white),
                                        onChanged: (value) {
                                            if(conversations.any((element) => element.title==value)){
                                                setState((){
                                                  duplicateTitle='conversation name must be unique';
                                                });
                                            }
                                            else{
                                              setState((){
                                                duplicateTitle='';
                                              });
                                            }
                                          conversationName=value;
                                        },
                                        decoration: InputDecoration(
                                          errorText: duplicateTitle.isEmpty ? null : duplicateTitle,
                                          counterStyle: TextStyle(color: Colors.white),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: backgroundColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(117, 172, 157, 1)),
                                          ),
                                          hintText: 'Enter conversation name',
                                          hintStyle: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: (){
                                          if(!conversations.any((element) => element.title==conversationName)){
                                            Navigator.pop(context);
                                            _firestore.collection('users').doc(
                                                (loggedInUser?.email).toString())
                                                .collection('conversations').doc(
                                                conversationName)
                                                .set({
                                              'title': conversationName,
                                              'timestamp': FieldValue.serverTimestamp()
                                            });
                                            navigateToChatScreen(
                                                conversationName);
                                          }
                                        }, child: Center(
                                          child: Container(
                                              width: 230,
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(117, 172, 157, 1),
                                                  borderRadius: BorderRadius.circular(8)
                                              ),
                                              child: const Center(
                                                child: Text('Start Conversation',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5
                                                  ),
                                                ),
                                              )
                                          ),
                                        ))
                                      ],
                                    );},
                                  )
                                );
                              });
                            },
                            child: Container(
                              color: foregroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text('New Conversation',
                                      style: TextStyle(
                                          color: Colors.white
                                      ))
                                ]
                        ),
                            ),
                          ),)
                      ],
                    ),
                  )
              ),
            ),
          ),
        )
    );
  }
}

final GlobalKey<_UserScreenState> userScreen = GlobalKey<_UserScreenState>();
