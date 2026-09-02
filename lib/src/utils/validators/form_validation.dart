import '../../common/widgets/extension/translation_extension.dart';

class FormValidation {
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "formValidation.enterPassword".trns();
    }
    if (password.length < 6) {
      return "formValidation.passwordMinLength".trns();
    }
    return null;
  }

  static String? validateRegisterConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "formValidation.confirmPassword".trns();
    } else if (password != confirmPassword) {
      return "formValidation.passwordMismatch".trns();
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "formValidation.enterName".trns();
    } else if (name.length < 3) {
      return "formValidation.nameMinLength".trns();
    } else if (!RegExp(r'^[a-zA-Z. ]+$').hasMatch(name)) {
      return "formValidation.nameInvalid".trns();
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "formValidation.enterPhone".trns();
    } else if (!RegExp(r'^[+0-9]+$').hasMatch(phone)) {
      return "formValidation.phoneInvalid".trns();
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "formValidation.enterEmail".trns();
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      return "formValidation.invalidEmail".trns();
    }
    return null;
  }

  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return "formValidation.enterUsername".trns();
    } else if (username.length < 3) {
      return "formValidation.usernameMinLength".trns();
    }
    return null;
  }

  static String? validateCountry(String? country) {
    if (country == null || country.isEmpty) {
      return "formValidation.selectCountry".trns();
    }
    return null;
  }

  static String? validateCustomField(String? value, String name) {
    if (value == null || value.isEmpty) {
      return "${"formValidation.enterYour".trns()}$name";
    }
    return null;
  }
}
