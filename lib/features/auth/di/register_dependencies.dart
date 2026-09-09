import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/config/app_config.dart';
import '../application/use_cases/register.dart';
import '../domain/repositories/register_repository.dart';
import '../infrastructure/repositories/api_register_repository.dart';
import '../presentation/cubits/register_cubit.dart';

final GetIt registerServiceLocator = GetIt.instance;

void configureRegisterDependencies(GetIt serviceLocator) {
  if (serviceLocator.isRegistered<Register>()) return;

  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    ),
  );
  serviceLocator.registerLazySingleton<RegisterRepository>(
    () => ApiRegisterRepository(client: serviceLocator<Dio>()),
  );
  serviceLocator.registerLazySingleton(
    () => Register(serviceLocator<RegisterRepository>()),
  );
  serviceLocator.registerFactory(
    () => RegisterCubit(serviceLocator<Register>()),
  );
}