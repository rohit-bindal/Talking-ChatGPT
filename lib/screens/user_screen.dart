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
  String conversationName = 'Talk with ChatGPT';
  String email = '';
  String password = '';
  bool showSpinner = false;
  List<ConversationCard> conversations = [];
  bool showConversations = false;
  int id = 0;

  void removeCard(int id){
    int index = 0;
    for(int i=0; i<conversations.length; i++){
      if(conversations[i].id == id){
        index = i;
        break;
      }
    }
    setState(() {
      conversations.removeAt(index);
    });
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
                              child: conversations.length==0 ? Center(
                                child: Text("You don't have any conversation", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300
                                ),),

                              ) : Padding(
                                padding: const EdgeInsets.only(left: 25, right:25, top:75, bottom: 25),
                                child: ListView.builder(
                                  itemCount: conversations.length,
                                  itemBuilder: (context, index){
                                    return conversations[index];
                                  },
                                ),
                              )
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(context: context, builder: (context){
                                return Container(
                                  child: AlertDialog(
                                    backgroundColor: Color.fromRGBO(32, 33, 35, 1),
                                    title: Text('Conversation Name', style: TextStyle(color: Colors.white),),
                                    content: TextField(
                                      maxLength: 30,
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (value) {
                                        conversationName=value;
                                      },
                                      decoration: InputDecoration(
                                        counterStyle: TextStyle(color: Colors.white),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color.fromRGBO(52, 53, 65, 1)),
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
                                        Navigator.pop(context);
                                        setState(() {
                                          conversations.add(ConversationCard(
                                            title: conversationName,
                                            removeCard: removeCard,
                                            id: id,
                                            navigate: navigateToChatScreen,
                                          ),
                                          );
                                          id++;
                                          showConversations=true;
                                        });
                                        navigateToChatScreen(conversationName);
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
                                  )
                                );
                              });
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

final GlobalKey<_UserScreenState> userScreen = GlobalKey<_UserScreenState>();
