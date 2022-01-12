import 'package:chat/providers/chat_provider.dart';
import 'package:chat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => AuthProvider() ),
        ChangeNotifierProvider( create: (_) => SocketProvider() ),
        ChangeNotifierProvider( create: (_) => ChatProvider() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat',
        routes: routes,
        initialRoute: 'splash',
      ),
    );
  }
}
