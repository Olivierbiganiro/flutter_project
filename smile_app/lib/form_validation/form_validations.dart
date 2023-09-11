import 'package:flutter/material.dart';

//Username validation
String? Usernamevalidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is Required';
  }
}

//Email validation
String? Emailvalidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is Required';
  }

  if (!RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      .hasMatch(value)) {
    return 'Please enter a valid email Address';
  }
}

//Pasword validation
String? validatePasword(String? value) {
  bool UpperLetter = false;

  bool LowerLetter = false;

  bool Number = false;
  if (value == null || value.isEmpty) {
    return "Pasword is required";
  } else if (value.length >= 3 && value.length < 16) {
    int i = 0;
    for (int i = 0;
        i < value.length && !(Number && UpperLetter && LowerLetter);
        i++) {
      if (value.codeUnitAt(i) >= 'A'.codeUnitAt(0) &&
          value.codeUnitAt(i) <= "Z".codeUnitAt(0)) {
        UpperLetter = true;
      } else if (value.codeUnitAt(i) >= 'a'.codeUnitAt(0) &&
          value.codeUnitAt(i) <= "z".codeUnitAt(0)) {
        LowerLetter = true;
      } else if (value.codeUnitAt(i) >= '0'.codeUnitAt(0) &&
          value.codeUnitAt(i) <= "9".codeUnitAt(0)) {
        Number = true;
      }
    }
    if (Number && UpperLetter && LowerLetter) {
    } else {
      return ("Valid password must be PascalCase and symbol");
    }
  } else {
    return ("valid pasword must be \n"
        "At least 1 letter between [a-z] and 1 letter between [A-Z] \n"
        "At least 1 number between [0-9]\n"
        "And one Symbol optional \n");
  }
}
