import 'package:flutter/material.dart';
import 'package:chat/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> routes = {

  'login': (_) => const LoginScreen(),
  'register': (_) => const RegisterScreen(),
  'home': (_) => const HomeScreen(),
  'chat': (_) => const ChatScreen(),
  'splash': (_) => const SplashScreen(),

};
