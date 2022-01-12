


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


showAlert( BuildContext context, String title, String text ) {


  if ( Platform.isAndroid ) {
    return showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text( title ),
        content: Text( text ),
        actions: [

          MaterialButton(
            child: const Text('Ok'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
          )

        ],
      )
    );  
  }


  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text( title ),
      content: Text( text ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );

  

}