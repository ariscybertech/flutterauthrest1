import 'dart:async';

class ValidationMixin {
  // with Provider state
  final validatorUsername = new StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      // if (email.isEmpty) {
      //   sink.addError('Email is required');
      // } else if (!email.contains('@')) {
      //   sink.addError('Please enter a valid email');
      // } else if (email.contains(' ')) {
      //   sink.addError('Space not allowd! 😏');
      // } else {
      //   sink.add(email);
      // }
    },
  );

  final validatorPassword = new StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (!ValidationMixin()._validatePassword(password)) {
        sink.addError('Password is not valid!');
      } else {
        sink.add(password);
      }
    },
  );
  // without Provider state

  bool _validatePassword(String password) {
    var regExp = new RegExp(r'^(?=.*?[A-Z][a-z]).{8,}$');
    // if (password.isEmpty) {
    //   return false;
    // }
    // if (password.length < 8) {
    //   return false;
    // }
    if (regExp.hasMatch(password)) {
      return false;
    }
    return true;
  }
}
