// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Mediops';

  @override
  String get signInTitle => 'Bienvenido de nuevo';

  @override
  String get signUpTitle => 'Crear Cuenta';

  @override
  String get signInSubtitle =>
      'Bienvenido de nuevo, por favor ingresa tus datos';

  @override
  String get signUpSubtitle => 'Regístrate para comenzar con Mediops';

  @override
  String get signInTab => 'Ingresar';

  @override
  String get signUpTab => 'Registrarse';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get emailHint => 'nombre@empresa.com';

  @override
  String get emailErrorEmpty => 'Ingresa un correo electrónico válido';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get fullNameHint => 'Dra. Laura López';

  @override
  String get fullNameErrorEmpty => 'Ingresa tu nombre completo';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => '••••••••';

  @override
  String get passwordErrorEmpty => 'Ingresa tu contraseña';

  @override
  String get passwordErrorLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get continueButton => 'Continuar';

  @override
  String get signUpButton => 'Registrarse';

  @override
  String get registrationSuccess =>
      'Registro exitoso. Revisa tu correo para verificar la cuenta.';

  @override
  String get orContinueWith => 'O CONTINUAR CON';
}
