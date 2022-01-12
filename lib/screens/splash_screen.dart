


import 'dart:io';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/socket_provider.dart';
import 'package:chat/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatelessWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkAuthState(context),
        builder: (context, snapshot) {
          return Center(
            child: 
              Platform.isAndroid 
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : const CupertinoActivityIndicator()
          );
        },
      ),
    );
  }


  Future checkAuthState( BuildContext context ) async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    final isAuthenticated = await authProvider.isLoggedIn();
    
    if ( isAuthenticated ) {

      //Conectar al servidor de socket
      socketProvider.connect();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );

    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }


  }


}