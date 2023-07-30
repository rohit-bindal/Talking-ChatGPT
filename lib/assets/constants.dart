import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

final String? API_KEY = dotenv.env['GPT_API_KEY'];
const Color backgroundColor = Color.fromRGBO(52, 53, 65, 1);
const Color foregroundColor = Color.fromRGBO(32, 33, 35, 1);
const String title = 'Talking ChatGPT';
const String subTitle = 'FOR CONVENIENT INTERACTION';