import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

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
                        const Expanded(
                            flex: 1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Talking ChatGPT',
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text('FOR CONVENIENT INTERACTION',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        letterSpacing: 2,
                                      )
                                  ),
                                ]
                            )),
                        Expanded(
                          flex: 5,
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
                                    const Image(
                                      width: 75,
                                      image: AssetImage('assets/images/ChatGPT_logo.png'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical:55),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Email',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20
                                            ),),
                                          TextField(
                                            keyboardType: TextInputType.emailAddress,
                                            onChanged: (String value) {
                                              email = value;
                                            },
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(52, 53, 65, 1)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(117, 172, 157, 1)),
                                              ),
                                              hintText: 'Enter your Email',
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                          )],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 50,
                                          right: 50
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Password',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20
                                            ),),
                                          TextField(
                                            obscureText: true,
                                            onChanged: (String value) {
                                              password = value;
                                            },
                                            style: TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(52, 53, 65, 1)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color.fromRGBO(117, 172, 157, 1)),
                                              ),
                                              hintText: 'Enter your Password',
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 65,
                                          ),
                                          GestureDetector(
                                              onTap: () async{
                                                try{
                                                  setState(() {
                                                    showSpinner = true;
                                                  });
                                                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                                                  if(newUser != null){
                                                    Navigator.pushNamed(context, 'user_screen');
                                                  }
                                                  setState(() {
                                                    showSpinner = false;
                                                  });
                                                }
                                                catch (e){
                                                  print(e);
                                                }
                                              },
                                              child: Container(
                                                  width: 300,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(117, 172, 157, 1),
                                                      borderRadius: BorderRadius.circular(8)
                                                  ),
                                                  child: const Center(
                                                    child: Text('SIGN UP',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  )
                                              )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 80),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Already have an Account?",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    )
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, 'login_screen');
                                                  },
                                                  child: Text(
                                                      'Login',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(117, 172, 157, 1),
                                                        fontWeight: FontWeight.w600,
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ),
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
