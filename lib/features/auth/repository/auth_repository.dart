import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddittdemo/core/constants/constants.dart';
import 'package:reddittdemo/core/constants/firebase_constants.dart';
import 'package:reddittdemo/core/failure.dart';
import 'package:reddittdemo/core/providers/firebase_providers.dart';
import 'package:reddittdemo/core/type_defs.dart';
import 'package:reddittdemo/features/models/user_model.dart';

// final userProvider = StateProvider<UserModel?>((ref) => null);

//auth repo
final authRepositoryProvider = Provider((ref) =>
  AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider)
  )
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({ required FirebaseFirestore firestore,
    required FirebaseAuth auth, required GoogleSignIn googleSignIn})
      : _auth = auth, _firestore = firestore, _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogleTwo() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
          credential);

      late UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser == false) {
        userModel = UserModel(
            name: userCredential.user!.displayName ?? 'No Name',
            profilePic: userCredential.user!.photoURL ?? Constants.logoPath,
            banner: Constants.logoPath,
            uid: userCredential.user!.uid,
            isAuthenticated: true
            // karma: 0,
            // awards: []
        );
        await _users.doc(userCredential.user!.uid).set(
          userModel.toMap()
        );
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      print(userModel.name);
      return right(userModel);
    } on FirebaseException catch(e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

       UserModel userModel;
        userModel = UserModel(
            name: 'Guest',
            profilePic: Constants.logoPath,
            banner: Constants.logoPath,
            uid: userCredential.user!.uid,
            isAuthenticated: false
        );
        await _users.doc(userCredential.user!.uid).set(
            userModel.toMap()
        );

      print(userModel.name);
      return right(userModel);
    } on FirebaseException catch(e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) =>
        UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}