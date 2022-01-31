import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetConnectionChecker _icc = InternetConnectionChecker();
  late StreamSubscription _iccSubscription;
  InternetCubit() : super(InternetLoading()) {
    _iccSubscription = _icc.onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        emit(InternetConnected());
      } else if (event == InternetConnectionStatus.disconnected) {
        emit(InternetDisconnected());
      }
      // ignore: argument_type_not_assignable_to_error_handler
    }, onError: (_) => emit(InternetError()));
  }
  @override
  Future<void> close() {
    // TODO: implement close
    _iccSubscription.cancel();
    return super.close();
  }
}
