import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:product_catalog/core/network/api_client.dart';
import 'package:product_catalog/features/products/data/repositories/product_repository.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Features
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository(sl()));
}
