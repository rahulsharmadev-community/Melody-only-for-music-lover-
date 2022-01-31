import 'dart:convert';
import 'package:audio_service/audio_service.dart';

class Song {
  Song({
    required this.id,
    required this.title,
    required this.url,
    required this.artist,
    required this.artistLink,
    required this.provider,
  });

  final String id;
  final String title;
  final String url;
  final String artist;
  final String artistLink;
  final String provider;

  factory Song.fromRawJson(String str) => Song.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        artist: json["artist"] ?? '',
        artistLink: json["artistLink"] ?? '',
        provider: json["provider"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "artist": artist,
        "artistLink": artistLink,
        "provider": provider,
      };

  MediaItem toMediaItem() =>
      MediaItem(id: url, title: title, artist: artist, extras: toJson());
}
