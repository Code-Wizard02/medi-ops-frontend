import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/di/register_dependencies.dart';
import '../../features/auth/application/use_cases/get_current_session.dart';
import '../../features/auth/application/use_cases/sign_in.dart';
import '../../features/auth/application/use_cases/sign_out.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/infrastructure/repositories/fake_auth_repository.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../cubits/settings_cubit.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  configureRegisterDependencies(serviceLocator);
  if (serviceLocator.isRegistered<AuthRepository>()) return;

  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);
  serviceLocator.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(serviceLocator<SharedPreferences>()),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(FakeAuthRepository.new);
  serviceLocator.registerLazySingleton(
    () => GetCurrentSession(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => SignIn(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => SignOut(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerFactory(
    () => AuthCubit(
      getCurrentSessionUseCase: serviceLocator<GetCurrentSession>(),
      signInUseCase: serviceLocator<SignIn>(),
      signOutUseCase: serviceLocator<SignOut>(),
    ),
  );
}
