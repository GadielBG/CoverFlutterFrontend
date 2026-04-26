import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cover/domain/repositories/auth_repository.dart';
import 'package:cover/data/repositories/auth_repository_impl.dart';
import 'package:cover/core/network/api_client.dart';
import 'package:cover/presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    ),
  );
}
