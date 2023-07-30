import 'package:flutter/material.dart';
import '../utils/authentication_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return const AuthenticationUI(
      forgotPasswordEnabled: true,
      buttonText: 'LOGIN',
      bottomText: "Don't have an Account?",
      bottomButtonText: 'Sign Up',
    );
  }
}
