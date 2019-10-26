import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/HttpException.dart';
import '../endpoint/endpoint_dev.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final urlSignup = EndpointDev.signup;
  final urlSignin = EndpointDev.signin;

  Future<void> _authenticate(String email, String password, String url) async {
    try {

      final bodyAuth = json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      final response = await http.post(url, body: bodyAuth);
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      print(responseData);
      print(bodyAuth);

    } catch (error) {
     throw HttpException(error.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, urlSignup);
  }

  Future<void> signIn(String email, String password) async {
    print(urlSignin);
    return _authenticate(email, password, urlSignin);
  }
}
