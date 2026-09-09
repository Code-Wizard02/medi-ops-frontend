import 'value_object.dart';

class Email extends ValueObject<String> {
  const Email(super.value);

  @override
  String? validate() {
    if (value.trim().isEmpty) {
      return 'El correo electrónico no puede estar vacío.';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Ingresa un correo electrónico válido.';
    }
    return null;
  }
}