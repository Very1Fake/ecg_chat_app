import 'package:ecg_chat_app/utils/consts.dart';

extension EmailValidator on String {
  bool isValidUsername() {
    return length >= 3 && length <= 24;
  }

  bool isValidPassword() {
    return length >= 6 && length <= 128;
  }

  bool isValidEmail() {
    return RegExp(patternEmail).hasMatch(this);
  }
}
