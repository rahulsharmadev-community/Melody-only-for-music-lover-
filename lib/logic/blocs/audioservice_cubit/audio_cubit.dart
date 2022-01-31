import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '/logic/service/audioPlayerHandler.dart';
import 'package:rxdart/rxdart.dart';
part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioPlayerHandler audioPlayerHandler;
  final AudioPlayer audioPlayer;
  MediaItem? mediaItem;
  PlaybackState? playbackState;
  AudioCubit(this.audioPlayerHandler, this.audioPlayer)
      : super(AudioState(
            audioPlayerHandler: audioPlayerHandler,
            audioPlayer: audioPlayer,
            playbackState: PlaybackState())) {
    audioPlayerHandler.mediaItem.listen((event) {
      if (event != null) emit(state._setMediaItem(event));
    });
    audioPlayerHandler.playbackState.listen((event) {
      emit(state._setplaybackState(event));
    });
  }
  emitSetIsSongLoading(bool value) => emit(state._setIsSongLoading(value));

  Stream<StreamData> get audioPlayerStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, StreamData>(
          audioPlayer.positionStream,
          _bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => StreamData(
              position, bufferedPosition, duration ?? Duration.zero));

  get _bufferedPositionStream => audioPlayerHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
}

class StreamData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  StreamData(this.position, this.bufferedPosition, this.duration);
}
