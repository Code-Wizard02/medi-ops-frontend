import 'package:equatable/equatable.dart';

class VerificationCode extends Equatable {
  const VerificationCode(this.value);

  final String value;

  String? validate() {
    if (value.isEmpty) {
      return 'El código es requerido.';
    }
    final regex = RegExp(r'^\d{6}$');
    if (!regex.hasMatch(value)) {
      return 'El código debe tener 6 dígitos numéricos.';
    }
    return null;
  }

  @override
  List<Object?> get props => [value];
}
