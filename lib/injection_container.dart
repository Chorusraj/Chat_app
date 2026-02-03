import 'package:chat_app/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:chat_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:chat_app/features/auth/domain/usecases/logout_user.dart';
import 'package:chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chat_app/features/chat/data/datasources/chat_remote_datasource_impl.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/usecases/get_message.dart';
import 'package:chat_app/features/chat/domain/usecases/get_user_chats.dart';
import 'package:chat_app/features/chat/domain/usecases/send_message.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:chat_app/features/user/data/datasources/user_remote_datasource_impl.dart';
import 'package:chat_app/features/user/domain/repositories/user_repository.dart';
import 'package:chat_app/features/user/domain/repositories/user_repository_impl.dart';
import 'package:chat_app/features/user/domain/usecases/get_all_users.dart';
import 'package:chat_app/features/user/presentation/bloc/user_list_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logout: sl(),
      getCurrentUser: sl(),
    ),
  );
  sl.registerFactory(() => ChatListBloc(getUserChats: sl()));
  sl.registerFactory(() => UserListBloc(getAllUsers: sl()));

  // UseCases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => GetUserChats(sl()));
  sl.registerLazySingleton(() => GetAllUsers(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
