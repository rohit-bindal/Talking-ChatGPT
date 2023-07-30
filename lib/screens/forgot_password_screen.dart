import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../assets/constants.dart';
import '../services/firebase/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  String email = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: foregroundColor,
        ),
        backgroundColor: foregroundColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                color: Colors.white,
                size: 70,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Forgot your password?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Enter your email below to receive your password reset instructions",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) {
                    email = value;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: backgroundColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(117, 172, 157, 1)),
                    ),
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    setState(() {
                      showSpinner = true;
                    });
                    firebaseAuth.resetPassword(email);
                    setState(() {
                      showSpinner = false;
                    });
                    _scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(
                        content: Text('Sent! Please check your mailbox.'),
                        duration: Duration(seconds: 4),
                      ),
                    );
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    _scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(
                        content: Text('Invalid email.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(117, 172, 157, 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        'SEND',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
