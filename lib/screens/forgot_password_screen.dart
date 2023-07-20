import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:Color.fromRGBO(32, 33, 35, 1) ,
      ),
      backgroundColor: Color.fromRGBO(32, 33, 35, 1),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.lock, color:Colors.white, size: 70,),
            SizedBox(height: 50,),
            Text(
              'Forgot your password?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 5,),
            Text("Enter your email below to receive your password reset instructions",
              textAlign: TextAlign.center,
              style: TextStyle(
              color: Colors.white,
                fontWeight: FontWeight.w300
            ),),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  email=value;
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
              ),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: () async {
                try {
                  setState(() {
                    showSpinner=true;
                  });
                  await _auth.sendPasswordResetEmail(email: email);
                  setState(() {
                    showSpinner=false;
                  });
                  timerSnackbar(
                      context: context,
                      contentText: "Sent! Please check your mailbox.",
                      afterTimeExecute: () => Navigator.pushNamed(context, 'login_screen'),
                      second: 5
                  );
                }
                catch (e) {
                  setState(() {
                    showSpinner=false;
                  });
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
                    child: Text('SEND',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
