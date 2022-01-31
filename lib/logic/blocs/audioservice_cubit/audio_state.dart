part of 'audio_cubit.dart';

@immutable
class AudioState extends Equatable {
  final AudioPlayerHandler audioPlayerHandler;
  final AudioPlayer audioPlayer;
  final MediaItem? mediaItem;
  final PlaybackState? playbackState;
  final bool isSongLoading;
  const AudioState({
    required this.audioPlayerHandler,
    required this.audioPlayer,
    this.isSongLoading = false,
    this.mediaItem,
    this.playbackState,
  });

  _setIsSongLoading(bool value) => copyWith(isSongLoading: value);
  _setMediaItem(MediaItem value) => copyWith(mediaItem: value);
  _setplaybackState(PlaybackState value) => copyWith(playbackState: value);

  AudioState copyWith(
          {AudioPlayerHandler? audioHandler,
          AudioPlayer? audioPlayer,
          MediaItem? mediaItem,
          PlaybackState? playbackState,
          bool? isSongLoading}) =>
      AudioState(
          audioPlayerHandler: audioHandler ?? this.audioPlayerHandler,
          audioPlayer: audioPlayer ?? this.audioPlayer,
          mediaItem: mediaItem ?? this.mediaItem,
          playbackState: playbackState ?? this.playbackState,
          isSongLoading: isSongLoading ?? this.isSongLoading);

  @override
  // TODO: implement props
  List<Object?> get props => [
        mediaItem,
        playbackState,
        isSongLoading,
        audioPlayerHandler,
        audioPlayer
      ];
}
