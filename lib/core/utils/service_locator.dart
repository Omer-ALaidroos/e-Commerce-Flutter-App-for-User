
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/auth/repo/auth_local_data_source.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/features/forgetPassword/repo/forget_password_repo.dart';
import 'package:e_commerce_app/features/my_Details/cubit/edit_cubit.dart';
import 'package:e_commerce_app/features/my_Details/cubit/user_details_cubit.dart';
import 'package:e_commerce_app/features/my_Details/repo/user_details_repo.dart';
import 'package:e_commerce_app/features/order/cubit/order_cubit.dart';
import 'package:e_commerce_app/features/order/cubit/order_details_cubit.dart';
import 'package:e_commerce_app/features/order/repo/order_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/repo/cart_repo.dart';
import 'package:e_commerce_app/features/auth/cubit/auth/auth_cubit.dart';
import 'package:e_commerce_app/features/auth/cubit/register/register_cubit.dart';
import 'package:e_commerce_app/features/auth/repo/auth_repo.dart';
import 'package:e_commerce_app/features/auth/repo/register_repo.dart';
import 'package:e_commerce_app/features/home/cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/product_cubit.dart';
import 'package:e_commerce_app/features/home/repo/home_repo.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  DioHelper dio = DioHelper();

  // Dio Helper
  sl.registerSingleton<DioHelper>(dio);

  // External & Storage Helpers
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => StorageHelper());
  sl.registerLazySingleton(() => AuthLocalDataSource(sl<FlutterSecureStorage>()));

  // Repos
  sl.registerLazySingleton(() => AuthRepo(sl<DioHelper>()));
  sl.registerLazySingleton(() => HomeRepo(sl<DioHelper>()));
  sl.registerLazySingleton(() => CartRepo(sl<DioHelper>()));
  sl.registerLazySingleton(() => RegisterRepo(sl<DioHelper>()));
  sl.registerLazySingleton(() => OrderRepo(sl<DioHelper>()));
  sl.registerLazySingleton(() => UserDetailsRepo(sl<DioHelper>()));
  sl.registerLazySingleton(() => ForgetPasswordRepo(sl<DioHelper>()));


  // Cubit
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
  sl.registerFactory(() => ProductCubit(sl<HomeRepo>()));
  sl.registerFactory(() => CategoriesCubit(sl<HomeRepo>()));
  sl.registerFactory(() => CartCubit(sl<CartRepo>()));
  sl.registerFactory(() => RegisterCubit( AuthRepo(sl<DioHelper>())));
  sl.registerFactory(() => OrderCubit(sl<OrderRepo>()));
  sl.registerFactory(() => OrderDetailsCubit(sl<OrderRepo>()));
  sl.registerFactory(() => UserDetailsCubit(sl<UserDetailsRepo>()));
  sl.registerFactory(() => EditCubit(sl<UserDetailsRepo>()));
  sl.registerFactory(() => ForgetPasswordCubit(sl<ForgetPasswordRepo>()));
}
