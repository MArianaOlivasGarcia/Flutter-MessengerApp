import 'package:flutter/material.dart';


class Labels extends StatelessWidget {

  final void Function() onTap;
  final String title;
  final String textButton;

  Labels({
    required this.onTap,
    required this.title,
    required this.textButton
  });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          
          Text( title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300
            ),
          ),

          const SizedBox(
            height: 10,
          ),


          GestureDetector(
            child: Text( textButton ,
              style: const TextStyle(
                color: Colors.deepPurple ,
                fontSize: 15,
                fontWeight: FontWeight.w500
              ),
            ),
            onTap: onTap
          ),

        ],
      ),
    );
  }
}