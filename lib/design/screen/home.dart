import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/blocs/usercache_cubit/usercache_cubit.dart';
import '/logic/repo/database.dart';
import 'musicPlayingScreen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  card(Database _database, int index, int i) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: InkWell(
            onTap: !state.isSongLoading
                ? () async {
                    if (_database.playlistsBlock[index].playlists[i] ==
                        _database.activePlaylist) {
                      Navigator.of(context).pushNamed('/music_playing_screen');
                    } else {
                      _database.setActivePlaylist(
                          _database.playlistsBlock[index].playlists[i]);
                      await _database.playSongsBlock(
                          _database
                              .playlistsBlock[index].playlists[i].songsBlockId,
                          context);
                    }
                  }
                : null,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              children: [
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: BlocBuilder<UserCacheCubit, UserCache>(
                    builder: (context, state) {
                      return CachedNetworkImage(
                        imageUrl:
                            _database.playlistsBlock[index].playlists[i].image,
                        placeholder: (_ctx, child) =>
                            Image.asset('assets/images/placeholder.png'),
                        fit: BoxFit.fill,
                        filterQuality: state.dataSaveMode
                            ? FilterQuality.low
                            : FilterQuality.medium,
                      );
                    },
                  ),
                ),
                if (_database.playlistsBlock[index].playlists[i] ==
                        _database.activePlaylist &&
                    state.playbackState!.processingState !=
                        AudioProcessingState.idle)
                  InkWell(
                    onTap: () => state.playbackState!.playing
                        ? state.audioPlayerHandler.pause()
                        : state.audioPlayerHandler.play(),
                    child: CircleAvatar(
                      maxRadius: kToolbarHeight / 2,
                      backgroundColor: Colors.black54,
                      child: Icon(
                        state.playbackState!.playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  right: 8,
                  child: Text(
                    _database.playlistsBlock[index].playlists[i].title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Database>(
      builder: (_builder, _database, child) => RefreshIndicator(
          backgroundColor: Colors.black12,
          strokeWidth: 3,
          onRefresh: () async => await Future.delayed(
              const Duration(milliseconds: 500), _database.loadplaylistsBlock),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            itemCount: _database.playlistsBlock.length,
            itemBuilder: (itemBuilder, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                height: 200,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        _database.playlistsBlock[index].title,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount:
                              _database.playlistsBlock[index].playlists.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_build, i) =>
                              card(_database, index, i)),
                    )
                  ],
                )),
          )),
    );
  }
}
