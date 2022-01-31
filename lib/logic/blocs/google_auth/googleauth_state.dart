part of 'googleauth_cubit.dart';

@immutable
abstract class GoogleAuthState {
  User user = User.empty();
  get state => null;
}

class GoogleAuthSignIn extends GoogleAuthState {
  final User _user;
  GoogleAuthSignIn(this._user) {
    user = _user;
  }
}

class GoogleAuthSignOut extends GoogleAuthState {
  GoogleAuthSignOut();
}

class GoogleAuthError extends GoogleAuthState {
  GoogleAuthError();
}

class GoogleAuthProcessing extends GoogleAuthState {
  GoogleAuthProcessing();
}
