


import 'package:flutter/material.dart';

class AuthFormProvider extends ChangeNotifier {


  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  String name = '';
  String email = '';
  String password = '';

  bool isValid() {
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

}