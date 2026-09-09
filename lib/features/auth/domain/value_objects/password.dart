import 'value_object.dart';

class Password extends ValueObject<String> {
  const Password(super.value);

  @override
  String? validate() {
    if (value.isEmpty) return 'Ingresa una contraseña.';

    final rules = {
      'La contraseña debe tener al menos 8 caracteres.': value.length >= 8,
      'Debe contener al menos una letra mayúscula.': RegExp(r'[A-Z]').hasMatch(value),
      'Debe contener al menos una letra minúscula.': RegExp(r'[a-z]').hasMatch(value),
      'Debe contener al menos un número.': RegExp(r'[0-9]').hasMatch(value),
      'Debe contener al menos un carácter especial.': RegExp(r'[\W_]').hasMatch(value),
    };

    for (final rule in rules.entries) {
      if (!rule.value) return rule.key;
    }

    return null;
  }
}