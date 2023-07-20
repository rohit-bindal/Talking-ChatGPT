import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../utils/conversation_card.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;
  List<ConversationCard> conversations = [];
  bool showConversations = false;

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
                  color: Color.fromRGBO(52, 53, 65, 1),
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
                                        image: AssetImage('assets/images/white_chatgpt_logo.png')
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
                                          _auth.signOut();
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
                                  color: Color.fromRGBO(32, 33, 35, 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(55),
                                      topRight: Radius.circular(55)
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: !showConversations,
                                        child: Text(
                                      "You don't have any conversation !",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 16
                                          )
                                    ),),
                                    Visibility(
                                      visible: showConversations,
                                        child: Padding(
                                      padding: EdgeInsets.all(50),
                                      child: ListView(
                                        children: conversations,
                                      ),
                                    ),),
                                  ],
                                )
                              )
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'chat_screen');
                            },
                            child: Container(
                              color: Color.fromRGBO(32, 33, 35, 1),
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
