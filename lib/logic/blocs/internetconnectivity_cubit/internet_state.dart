part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

// all possible state of Internet Connection

class InternetLoading extends InternetState {
  InternetLoading();
}

class InternetError extends InternetState {
  InternetError();
}

class InternetConnected extends InternetState {
  InternetConnected();
}

class InternetDisconnected extends InternetState {
  InternetDisconnected();
}
