


import 'package:chat/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CustomMessage extends StatelessWidget {

  const CustomMessage({
    Key? key, 
    required this.text, 
    required this.uid,
    required this.animationController }) : super(key: key);

  final String text;
  final String uid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut
        ),
        child: Container(
          child: uid == authProvider.usuario.id
            ? _myMessage( size )
            : _notMyMessage( size ),
        ),
      ),
    );
  }


  Widget _myMessage(Size size){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          bottom: 8.0,
          left: size.width * 0.3,
          right: 8,
        ),
        child: Text( text,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurple[600],
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }

  Widget _notMyMessage( Size size ){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          bottom: 8.0,
          right: size.width * 0.3,
          left: 8,
        ),
        child: Text( text ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
}