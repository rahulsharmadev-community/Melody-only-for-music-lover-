part of 'usercache_cubit.dart';

@immutable
class UserCache extends Equatable {
  final List<Song> availableSongs;
  final bool autoPlay;
  final bool gapless;
  final bool dataSaveMode;
  const UserCache(
      {required this.availableSongs,
      required this.autoPlay,
      required this.gapless,
      required this.dataSaveMode});

  factory UserCache.fromRawJson(String str) =>
      UserCache.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCache.fromJson(Map<String, dynamic> json) => UserCache(
        availableSongs: List<Song>.from(
            json["availableSongs"].map((x) => Song.fromRawJson(x))),
        autoPlay: json["autoPlay"],
        gapless: json["gapless"],
        dataSaveMode: json["dataSaveMode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "availableSongs":
            List<dynamic>.from(availableSongs.map((e) => e.toRawJson())),
        "autoPlay": autoPlay,
        "gapless": gapless,
        "dataSaveMode": dataSaveMode,
      };

  _setAutoplay(bool value) => copyWith(autoPlay: value);
  _setGapless(bool value) => copyWith(gapless: value);
  _setDataSaveMode(bool value) => copyWith(dataSaveMode: value);

  UserCache copyWith(
          {List<Song>? availableSongs,
          bool? autoPlay,
          bool? gapless,
          bool? dataSaveMode}) =>
      UserCache(
          availableSongs: availableSongs ?? this.availableSongs,
          autoPlay: autoPlay ?? this.autoPlay,
          gapless: gapless ?? this.gapless,
          dataSaveMode: dataSaveMode ?? this.dataSaveMode);

  @override
  List<Object> get props => [availableSongs, autoPlay, gapless, dataSaveMode];
}
