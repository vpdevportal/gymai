import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymai/core/error/exceptions.dart';
import 'package:gymai/features/profile/data/models/user_profile_model.dart';

abstract class FirestoreProfileDataSource {
  Future<UserProfileModel?> getProfile({required String userId});
  Future<void> saveProfile(UserProfileModel model);
}

class FirestoreProfileDataSourceImpl implements FirestoreProfileDataSource {
  const FirestoreProfileDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String userId) =>
      _firestore.collection('users').doc(userId);

  @override
  Future<UserProfileModel?> getProfile({required String userId}) async {
    try {
      final snap = await _doc(userId).get();
      if (!snap.exists || snap.data() == null) return null;
      return UserProfileModel.fromJson({'userId': userId, ...snap.data()!});
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> saveProfile(UserProfileModel model) async {
    try {
      final data = model.toJson()..remove('userId');
      await _doc(model.userId).set(data, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }
}
