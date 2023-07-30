import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../assets/constants.dart';
import '../services/firebase/firebase_auth.dart';

class AuthenticationUI extends StatefulWidget {
  final bool forgotPasswordEnabled;
  final String buttonText;
  final String bottomText;
  final String bottomButtonText;

  const AuthenticationUI(
      {
        Key? key,
        required this.forgotPasswordEnabled,
        required this.buttonText,
        required this.bottomText,
        required this.bottomButtonText
      }
      ) : super(key: key);

  @override
  State<AuthenticationUI> createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String email = '';
  String password = '';
  bool showSpinner = false;
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ScaffoldMessenger(
          key: _scaffoldMessengerKey,
          child: Scaffold(
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
                          const Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 35,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(subTitle,
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
                                    color: foregroundColor,
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
                                        image: AssetImage('lib/assets/images/ChatGPT_logo.png'),
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
                                                  borderSide: BorderSide(color: backgroundColor),
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
                                                password=value;
                                              },
                                              style: TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: backgroundColor),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color.fromRGBO(117, 172, 157, 1)),
                                                ),
                                                hintText: 'Enter your Password',
                                                hintStyle: TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                            Visibility(
                                              visible: widget.forgotPasswordEnabled,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 175, top:10),
                                                child: InkWell(
                                                  hoverColor: Colors.blue,
                                                  onTap: (){
                                                    Navigator.pushNamed(context, 'forgot_password_screen');
                                                  },
                                                  child: Text('Forgot Password ?',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(117, 172, 157, 1),
                                                      fontWeight: FontWeight.w600,
                                                    ),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: widget.forgotPasswordEnabled ? 40 : 65,
                                            ),
                                            GestureDetector(
                                                onTap: () async {
                                                  try {
                                                    setState(() {
                                                      showSpinner = true;
                                                    });
                                                    final user;
                                                    if(widget.forgotPasswordEnabled) {
                                                      user = await firebaseAuth.singIn(email, password);
                                                    } else{
                                                      user = await firebaseAuth.singUp(email, password);
                                                    }
                                                    if(user != null){
                                                      Navigator.pushNamed(
                                                          context,
                                                          'user_screen');
                                                    }
                                                    setState(() {
                                                      showSpinner = false;
                                                    });
                                                  }
                                                  catch (e) {
                                                    setState(() {
                                                      showSpinner=false;
                                                    });
                                                    _scaffoldMessengerKey.currentState?.showSnackBar(
                                                      SnackBar(
                                                        content: Text('Invalid email or password.'),
                                                        duration: Duration(seconds: 3),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                    width: 300,
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(117, 172, 157, 1),
                                                        borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    child: Center(
                                                      child: Text(widget.buttonText,
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
                                                  Text(widget.bottomText,
                                                      style: TextStyle(
                                                          color: Colors.white
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      if(widget.forgotPasswordEnabled){Navigator.pushNamed(context, 'signup_screen');}
                                                      else{
                                                        Navigator.pushNamed(context, 'login_screen');
                                                      }
                                                    },
                                                    child: Text(
                                                        widget.bottomButtonText,
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
          ),
        )
    );
  }
}
