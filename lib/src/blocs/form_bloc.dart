import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_statefull/src/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

import '../mixins/validation_mixin.dart';

class FormBloc with ValidationMixin {
  final _username = new BehaviorSubject<String>();
  final _name = new BehaviorSubject<String>();
  final _errorMessage = new BehaviorSubject<String>();

  // getters: Changers
  Function(String) get changeUsername {
    addError(null);
    return _username.sink.add;
  }

  Function(String) get changePassword {
    addError(null);
    return _name.sink.add;
  }

  Function(String) get addError => _errorMessage.sink.add;
  // getters: Add stream
  Stream<String> get username => _username.stream.transform(validatorUsername);
  Stream<String> get password => _name.stream.transform(validatorPassword);
  Stream<String> get errorMessage => _errorMessage.stream;

  Stream<bool> get submitValidForm => Rx.combineLatest3(
        username,
        password,
        errorMessage,
        (e, p, er) => true,
      );

  var authInfo;
  // rgister
  dynamic register(BuildContext context) async {
    authInfo = AuthService();

    final res = await authInfo.register(_username.value, _name.value);
    final data = jsonDecode(res) as Map<String, dynamic>;

    if (data['status'] != 200) {
      addError(data['message']);
    } else {
      AuthService.setToken(data['token'], data['refreshToken']);
      Navigator.pushNamed(context, '/home');
      return data;
    }
  }

  // login
  dynamic login(BuildContext context) async {
    authInfo = AuthService();

    final res = await authInfo.login(_username.value, _name.value);
    final data = jsonDecode(res) as Map<String, dynamic>;

    if (data['status'] != 200) {
      addError(data['message']);
    } else {
      AuthService.setToken(data['token'], data['refreshToken']);
      Navigator.pushNamed(context, '/home');
      return data;
    }
  }

  // close streams
  dispose() {
    _username.close();
    _name.close();
    _errorMessage.close();
  }
}
