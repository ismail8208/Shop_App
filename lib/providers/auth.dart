import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }
//here 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  String? get token {
    return _token;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCknY4_QeAUWTqnyFsV0kRj4p7l6DPvUTg';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(milliseconds: int.parse(responseData['expiresIn'])));

/*
      _autoLogout();
*/
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });

      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    // as String
    final Map<String, Object> extracteData = json
        .decode(prefs.getString('userData').toString()) as Map<String, Object>;
    print('userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    print(prefs.get('userData'));
    // as String
    final expiryDate = DateTime.parse(extracteData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) return false;
    // as String
    _token = extracteData['token'] as String;
    _userId = extracteData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
/*
***********************************************************
    _autoLogout();
*/
    return true;
  }

  Future<void> logout() async {
    // = null
    _token = null;
    // = null
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
