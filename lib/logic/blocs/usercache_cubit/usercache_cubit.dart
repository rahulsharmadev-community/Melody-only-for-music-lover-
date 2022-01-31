import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:melody/logic/objects/song.dart';

part 'usercache.dart';

class UserCacheCubit extends Cubit<UserCache> with HydratedMixin {
  UserCacheCubit()
      : super(UserCache(
            availableSongs: [],
            autoPlay: true,
            gapless: true,
            dataSaveMode: true));

  void emitAutoplay(bool value) => emit(state._setAutoplay(value));
  void emitGapless(bool value) => emit(state._setGapless(value));
  void emitDataSaveMode(bool value) => emit(state._setDataSaveMode(value));
  void emitAvailableSongs(Song song) {
    List<Song> temp = state.availableSongs;
    temp.add(song);
    return emit(state.copyWith(availableSongs: temp));
  }

  @override
  UserCache? fromJson(Map<String, dynamic> json) => UserCache.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserCache state) => state.toJson();
}
