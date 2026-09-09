import 'value_object.dart';

class FullName extends ValueObject<String> {
  const FullName(super.value);

  @override
  String? validate() {
    if (value.trim().isEmpty) {
      return 'Ingresa tu nombre completo.';
    }
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres.';
    }
    return null;
  }
}