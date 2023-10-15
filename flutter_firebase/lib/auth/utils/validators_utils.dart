import 'package:get/get_utils/get_utils.dart';

class FormValidator{
  String? isValidName(String? text) {
    if (text == null || text.isEmpty || text.length < 3) {
      return "Este nombre NO es válido";
    }
    return null;
  }

  String? isValidEmail(String? text) {
    return (text ?? "").isEmail ? null : "Este email NO es válido";
  }

  String? isValidPass(String? text) {
    if (text == null || text.length < 6) {
      return "Esta contraseña es muy corta";
    }
    return null;
  }
}