


import 'dart:io';

class Environments {

  static String apiUrl = Platform.isAndroid ? 'http://192.168.1.71:8080/api' : 'http://localhost:8080/api';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.1.71:8080/' : 'http://localhost:8080/';

}