import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:melody/logic/objects/user.dart';
import 'package:meta/meta.dart';
part 'googleauth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  late GoogleSignIn _googleSignIn;
  // late String _userId;
  // String get userId => _userId;
  GoogleAuthCubit() : super(GoogleAuthProcessing()) {
    _googleSignIn = GoogleSignIn();
    _signInSilently();
  }

  void setUser(User data) => emit(GoogleAuthSignIn(data));
  // User get getUser => state.user;

  Future<void> _signInSilently() async {
    try {
      final _account = await _googleSignIn.signInSilently();
      emit(GoogleAuthSignIn(_toUser(_account)));
    } catch (error) {
      Exception('>> SignInSilently $error');
      emit(GoogleAuthSignOut());
    }
  }

  Future<void> signOut() async {
    try {
      final _account = await _googleSignIn.signOut();

      emit(GoogleAuthSignOut());
    } catch (error) {
      Exception('>> SignOut Error $error');
      emit(GoogleAuthError());
    }
  }

  Future<void> disconnect() async {
    try {
      final _account = await _googleSignIn.disconnect();
      _toUser(_account);
      emit(GoogleAuthSignOut());
    } catch (error) {
      Exception('>> SignOut Error $error');
      emit(GoogleAuthError());
    }
  }

  Future<void> signIn() async {
    try {
      final _account = await _googleSignIn.signIn();
      var _user = _toUser(_account);
      var docInstance = await FirebaseFirestore.instance
          .collection('users')
          .doc(_account!.id)
          .get();

      if (docInstance.exists) {
        emit(GoogleAuthSignIn(User.fromJson(docInstance.data()!)));
      } else {
        await _addUserToFirestore(_user);
        emit(GoogleAuthSignIn(_user));
      }
    } catch (error) {
      Exception('>> SignIn $error');
      emit(GoogleAuthError());
    }
  }

  Future<void> _addUserToFirestore(User _user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.userId)
        .set(_user.toJson());
  }

  User _toUser(GoogleSignInAccount? _account) => User(
      userId: _account!.id,
      name: _account.displayName!,
      email: _account.email,
      phoneNo: '',
      profilePic: _account.photoUrl!,
      authorization: false,
      serverAuthCode: _account.serverAuthCode!);
}
