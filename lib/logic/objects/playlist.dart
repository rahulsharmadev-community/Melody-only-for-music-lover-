import 'dart:convert';

class Playlist {
  Playlist(
      {required this.title,
      required this.image,
      required this.songsBlockId,
      required this.description});

  final String title;
  final String image;
  final String songsBlockId;
  final String description;

  factory Playlist.empty() =>
      Playlist(title: '', image: '', songsBlockId: '', description: '');

  factory Playlist.fromRawJson(String str) =>
      Playlist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
      image: json["image"],
      songsBlockId: json["songsBlockId"],
      title: json["title"],
      description: json["description"]);

  Map<String, dynamic> toJson() => {
        "image": image,
        "songsBlockId": songsBlockId,
        "title": title,
        "description": description
      };
}
