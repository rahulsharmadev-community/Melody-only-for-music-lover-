import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppthemeCubit extends Cubit<int> with HydratedMixin {
  AppthemeCubit() : super(0);

  void setApptheme(int index) => emit(index);

  @override
  int fromJson(Map<String, dynamic> json) => json['value'] as int;

  @override
  Map<String, int> toJson(int state) => {'value': state};
}
