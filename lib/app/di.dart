
import 'package:get_it/get_it.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:mvvm_first_c/app/app_prefs.dart';
import 'package:mvvm_first_c/data/data_source/remot_data_source.dart';
import 'package:mvvm_first_c/data/network/app_api.dart';
import 'package:mvvm_first_c/data/network/dio_factory.dart';
import 'package:mvvm_first_c/data/network/network_info.dart';
import 'package:mvvm_first_c/data/repository/repository_impl.dart';
import 'package:mvvm_first_c/domain/repository.dart';
import 'package:mvvm_first_c/domain/usecase/login_usecase.dart';
import 'package:mvvm_first_c/presentation/login/login_viewmodel.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;
Future<void> initAppModule() async {
  // Shared Preferences 
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  // App Preferences 
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  // Network Info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(DataConnectionChecker()));
  // Dio    
  instance.registerLazySingleton<DioFactoy>(() => DioFactoy (instance()));
  // App Service Client
  final dio = await instance<DioFactoy>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  // Remot Data Source 
  instance.registerLazySingleton<RemotDataSource>(
      () => RemotDataSourceImpilenter(instance()));
  // RepositoryImpl
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance()));

}
initLoginModule()
{ if(!GetIt.I.isRegistered<LoginUseCase>()){  
  instance.registerFactory<LoginUseCase>(() =>LoginUseCase(instance()) );
  instance.registerFactory<LoginViewModel>(() =>LoginViewModel(instance()) );
}
}