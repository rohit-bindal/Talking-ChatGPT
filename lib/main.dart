import 'package:flutter/material.dart';
import 'package:talking_chatgpt/screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/user_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const TalkingChatGPT());
}

class TalkingChatGPT extends StatelessWidget {
  const TalkingChatGPT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login_screen',
      routes: {
        'login_screen': (context) => const LoginScreen(),
        'signup_screen': (context) => const SignupScreen(),
        'user_screen': (context) => const UserScreen(),
        'chat_screen': (context) => const ChatScreen(),
        'forgot_password_screen': (context) => const  ForgotPasswordScreen(),
      }
    );
  }
}
