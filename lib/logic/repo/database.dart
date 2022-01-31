// ignore_for_file: camel_case_types,file_names

import 'package:flutter/cupertino.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/blocs/usercache_cubit/usercache_cubit.dart';
import 'package:melody/logic/repo/defaultFirebaseAPIs.dart';
import '../objects/block.dart';
import 'package:provider/provider.dart';
import '/logic/objects/playlist.dart';
import '/logic/objects/song.dart';

class Database extends ChangeNotifier {
  List<PlaylistsBlock> _playlistsBlock = [];
  late SongsBlock _songsBlock;
  List<Song> _songsList = [];
  List<Playlist> _playlists = [];
  Playlist? _activePlaylist;
  Playlist? get activePlaylist => _activePlaylist;
  List<PlaylistsBlock> get playlistsBlock => _playlistsBlock;
  SongsBlock get songsBlock => _songsBlock;
  List<Song> get songsList => _songsList;
  List<Playlist> get playlists => _playlists;

  addSongs(Song _song) {
    _songsList.add(_song);
    notifyListeners();
  }

  setSongs(List<Song> _songs) {
    _songsList = _songs;
    notifyListeners();
  }

  // Constructor
  Database() {
    loadplaylistsBlock();
    notifyListeners();
  }
  setActivePlaylist(Playlist playlist) {
    _activePlaylist = playlist;
    notifyListeners();
  }

  loadplaylistsBlock() async {
    try {
      var jsonBlockData =
          await DefaultFirebaseAPIs.playlistsBlock.getRequest(path: '');
      List<PlaylistsBlock> tempPlaylistsBlock = [];
      jsonBlockData!.forEach((key, value) {
        List<Playlist> tempPlaylist = [];
        List<String>.from(value['playlistsId']).forEach((e) async {
          var _jsonfile =
              (await DefaultFirebaseAPIs.playlists.getRequest(path: e))!;
          tempPlaylist.add(Playlist.fromJson(_jsonfile));
          notifyListeners();
        });
        tempPlaylistsBlock.add(PlaylistsBlock(
            playlists: tempPlaylist, id: key, title: value['title']));
      });
      _playlistsBlock = tempPlaylistsBlock;
      notifyListeners();
    } catch (error) {
      Exception('>>> $error');
    }
    notifyListeners();
  }

  playSongsBlock(String songsBlockId, BuildContext context) async {
    var _audioServiceProvider = context.read<AudioCubit>();
    _audioServiceProvider.emitSetIsSongLoading(true);
    _audioServiceProvider.audioPlayerHandler.stop();
    _audioServiceProvider.audioPlayerHandler.updateQueue([]);
    try {
      var _jsonResponse = (await DefaultFirebaseAPIs.songsBlock
          .getRequest(path: songsBlockId))!;
      _songsBlock = SongsBlock(
          id: songsBlockId,
          songsId: List<String>.from(_jsonResponse['songsId']));
      for (int index = 0; index < _songsBlock.songsId.length; index++) {
        Song tempSong =
            (await songResponse(_songsBlock.songsId[index], context))!;
        _audioServiceProvider.audioPlayerHandler
            .addQueueItem(tempSong.toMediaItem());
        if (index == 0) {
          _audioServiceProvider.audioPlayerHandler.seek(Duration.zero);
          _audioServiceProvider.audioPlayerHandler.play();
        }
      }
      notifyListeners();
      _audioServiceProvider.emitSetIsSongLoading(false);
    } catch (error) {
      Exception('>> $error');
    }
  }

  Future<Song?> songResponse(String songId, BuildContext context) async {
    if (context
        .read<UserCacheCubit>()
        .state
        .availableSongs
        .any((element) => element.id == songId)) {
      return context
          .read<UserCacheCubit>()
          .state
          .availableSongs
          .singleWhere((element) => element.id == songId);
    }
    try {
      var _jsonResponse =
          (await DefaultFirebaseAPIs.songs.getRequest(path: songId))!;
      _jsonResponse.addAll({'id': songId});
      final Song song = Song.fromJson(_jsonResponse);
      context.read<UserCacheCubit>().emitAvailableSongs(song);
      return song;
    } catch (error) {
      Exception('>> $error');
    }
  }

  setPlaylistsBlock(List<PlaylistsBlock> block) {
    _playlistsBlock = block;
    notifyListeners();
  }

  setPlaylists(List<Playlist> list) {
    _playlists = list;
    notifyListeners();
  }
}
