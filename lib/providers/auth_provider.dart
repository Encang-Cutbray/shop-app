import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/HttpException.dart';
import '../endpoint/endpoint_dev.dart';

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  final urlSignup = EndpointDev.signup;
  final urlSignin = EndpointDev.signin;

  final hardcodeEmail = 'moncos4@email.com';
  final hardcodePassword = 'secret214';

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

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      print(email);
      final bodyAuth = json.encode({
        'email': email.isEmpty ? hardcodeEmail: email,
        'password': password.isEmpty ? hardcodePassword :password,
        'returnSecureToken': true,
      });
      print(bodyAuth);

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

      autoLogout();
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

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void autoLogout(){ 
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeExpired = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeExpired), logout);
  }
}
