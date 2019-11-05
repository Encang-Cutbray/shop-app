import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  bool get isAuth => userToken != null;

  String get userToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId => _userId;

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      print(email);
      final bodyAuth = json.encode({
        'email': email.isEmpty ? hardcodeEmail : email,
        'password': password.isEmpty ? hardcodePassword : password,
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

      rememberUserLogin();
      autoLogout();
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> rememberUserLogin() async {
    final pref = await SharedPreferences.getInstance();
    final userLoginData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
    });
    pref.setString('userLoginData', userLoginData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if(!prefs.containsKey('userLoginData')){
      return false;
    }

    final extactUserLoginData =json.decode(prefs.getString('userLoginData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extactUserLoginData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extactUserLoginData['token'];
    _userId = extactUserLoginData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();

    return true;
  }

  Future<void> signUp(String email, String password) async =>
      _authenticate(email, password, urlSignup);

  Future<void> signIn(String email, String password,) async =>
      _authenticate(email, password, urlSignin);

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    clearUserLogin();
  }

  Future<void> clearUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeExpired = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeExpired), logout);
  }
}
