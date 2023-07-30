import 'package:flutter/material.dart';
import '../utils/authentication_ui.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return const AuthenticationUI(
      forgotPasswordEnabled: false,
      buttonText: 'SIGN UP',
      bottomText: "Already have an Account?",
      bottomButtonText: 'Login',
    );
  }
}
