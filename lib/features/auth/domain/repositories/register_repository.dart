import '../../../../core/result/app_result.dart';

import '../value_objects/email.dart';
import '../value_objects/full_name.dart';
import '../value_objects/password.dart';

abstract interface class RegisterRepository {
  Future<AppResult<void>> register({
    required Email email,
    required FullName fullName,
    required Password password,
    required String privacyVersion,
  });
}