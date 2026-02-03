import 'package:chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<UserModel>> getAllUsers() {
    return firestore.collection('users').snapshots().map(
          (snapshot) {
          return snapshot.docs
              .map((doc) { return UserModel.fromFirestore(doc.data(), doc.id);})
              .toList();
  });
  }
}