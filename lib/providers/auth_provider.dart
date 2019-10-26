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

  bool get isAuth {
    return userToken != null;
  }

  String get userToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

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

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, urlSignup);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, urlSignin);
  }
}
