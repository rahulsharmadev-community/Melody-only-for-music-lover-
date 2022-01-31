import 'package:melody/logic/objects/playlist.dart';

class PlaylistsBlock {
  PlaylistsBlock(
      {required this.playlists, required this.id, required this.title});
  final List<Playlist> playlists;
  final String id;
  final String title;

  factory PlaylistsBlock.empty() =>
      PlaylistsBlock(id: '', title: '', playlists: []);
}

class SongsBlock {
  SongsBlock({required this.id, required this.songsId});
  final List<String> songsId;
  final String id;

  factory SongsBlock.empty() => SongsBlock(id: '', songsId: []);
}
