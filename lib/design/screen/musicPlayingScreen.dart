import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import '/logic/repo/database.dart';
import '/logic/service/iScaffold.dart';
import '../widget/commonWidgets.dart';
import '../widget/seekBar.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class MusicPlayingScreen extends StatefulWidget {
  const MusicPlayingScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayingScreen> createState() => _MusicPlayingScreenState();
}

class _MusicPlayingScreenState extends State<MusicPlayingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IScafford(
        blur: 2,
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(Icons.music_note_rounded),
          title: Text(Provider.of<Database>(context).activePlaylist?.title ??
              'Playing Music'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.expand_more_rounded,
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<AudioCubit, AudioState>(builder: (context, _asp) {
              var mediaItem = _asp.mediaItem;
              return ListTile(
                textColor: Colors.white70,
                iconColor: Colors.white70,
                tileColor: Colors.transparent,
                dense: true,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        mediaItem?.title == null
                            ? ''
                            : '${mediaItem!.title.length > 15 ? mediaItem.title.substring(0, 15).trimRight() : mediaItem.title}..',
                        textWidthBasis: TextWidthBasis.parent,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/hq.png',
                      width: 48,
                    )
                  ],
                ),
                subtitle: Text(
                  mediaItem?.displayDescription ?? '',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                    onPressed: () => showSnackBar(
                        context, 'Requested service not available.'),
                    icon: const Icon(Icons.info_rounded)),
              );
            }),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: PlayAnimCard(_animationController),
                  ),
                  Expanded(
                      child: PlayingControllerWidget(_animationController)),
                ],
              ),
            ),
          ],
        ));
  }
}

class PlayAnimCard extends StatelessWidget {
  final AnimationController animationController;
  const PlayAnimCard(this.animationController, {Key? key}) : super(key: key);

  Color get ramdomColor => Color((Random().nextDouble() * 0xffffffff).toInt());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: MediaQuery.of(context).size.width / 2.5,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [ramdomColor, ramdomColor])),
      child: Lottie.asset(
        'assets/anim/${Random().nextInt(3) + 1}.json',
        controller: animationController,
        onLoaded: (composition) {
          animationController.duration = composition.duration;
          if ((context.read<AudioCubit>().state.audioPlayer.playing) &&
              !animationController.isAnimating) {
            animationController.repeat();
          }
        },
        fit: BoxFit.fitWidth,
        repeat: true,
      ),
    );
  }
}

class PlayingControllerWidget extends StatelessWidget {
  final AnimationController animationController;
  const PlayingControllerWidget(this.animationController, {Key? key})
      : super(key: key);

  Widget _iconButton(dynamic icon, VoidCallback onPressed,
          {required bool isImage,
          double size = 42,
          Color color = Colors.white}) =>
      GestureDetector(
        child: !isImage
            ? Icon(icon, color: color, size: size)
            : Image.asset(icon, width: size, color: color),
        onTap: onPressed,
      );

  showPlaylist(BuildContext context, AudioState _audioState) {
    Scaffold.of(context).showBottomSheet(
        (context) => StreamBuilder<List<MediaItem>>(
            stream: _audioState.audioPlayerHandler.queue,
            builder: (context, snapshot) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (itemBuilder, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              await _audioState.audioPlayerHandler
                                  .skipToQueueItem(index);
                            },
                            title: Text(snapshot.data?[index].title ?? ''),
                            leading: const Icon(Icons.music_note,
                                color: Colors.white),
                            trailing: Image.asset(
                              'assets/icons/hq.png',
                              width: 42,
                              color: Colors.red,
                            ),
                          ),
                        )),
              );
            }),
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))));
  }

  List<Map<String, dynamic>> get icons => [
        {
          'icon': 'assets/icons/repeat.png',
          'color': Colors.white,
          'mode': AudioServiceRepeatMode.all
        },
        {
          'icon': 'assets/icons/repeat-one.png',
          'color': Colors.red,
          'mode': AudioServiceRepeatMode.one
        },
        {
          'icon': 'assets/icons/repeat.png',
          'color': Colors.red,
          'mode': AudioServiceRepeatMode.none
        },
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(builder: (context, _asp) {
      var playbackState = _asp.playbackState;
      final repeatMode = playbackState!.repeatMode;
      const icons = [
        {'icon': 'assets/icons/repeat.png', 'color': Colors.white},
        {'icon': 'assets/icons/repeat.png', 'color': Colors.red},
        {'icon': 'assets/icons/repeat-one.png', 'color': Colors.red}
      ];
      const cycleModes = [
        AudioServiceRepeatMode.none,
        AudioServiceRepeatMode.all,
        AudioServiceRepeatMode.one,
      ];
      final index = cycleModes.indexOf(repeatMode);
      return Column(
        children: [
          SeekBar(
            showDuration: true,
            onChangeEnd: (newPosition) {
              _asp.audioPlayerHandler.seek(newPosition);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconButton(icons[index]['icon'], () {
                      _asp.audioPlayerHandler.setRepeatMode(cycleModes[
                          (cycleModes.indexOf(repeatMode) + 1) %
                              cycleModes.length]);
                    },
                        isImage: true,
                        color: icons[index]['color'] as Color,
                        size: 28),
                    _iconButton(
                        Icons.thumb_up_alt_outlined,
                        () => showSnackBar(
                            context, 'Requested service not available.'),
                        isImage: false,
                        size: 28),
                    _iconButton(
                        Icons.playlist_add_rounded,
                        () => showSnackBar(
                            context, 'Requested service not available.'),
                        isImage: false,
                        size: 28),
                    _iconButton(
                        Icons.queue_music_outlined,
                        _asp.audioPlayerHandler.queue.value.length != 1
                            ? () => showPlaylist(context, _asp)
                            : () {},
                        color: _asp.audioPlayerHandler.queue.value.length != 1
                            ? Colors.white
                            : Colors.white38,
                        isImage: false,
                        size: 28),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconButton(
                        Icons.replay_10_rounded,
                        () async => await _asp.audioPlayerHandler.seek(
                            _asp.playbackState!.position -
                                const Duration(seconds: 10)),
                        isImage: false,
                        size: 28),
                    _iconButton(
                        _asp.playbackState!.speed > 1
                            ? 'assets/icons/speed.png'
                            : _asp.playbackState!.speed == 1
                                ? 'assets/icons/idle.png'
                                : 'assets/icons/slow.png',
                        () async => _asp.playbackState!.speed > 1
                            ? _asp.audioPlayerHandler.setSpeed(1)
                            : _asp.playbackState!.speed == 1
                                ? _asp.audioPlayerHandler.setSpeed(0.9)
                                : _asp.audioPlayerHandler.setSpeed(1.1),
                        isImage: true,
                        size: 28),
                    _iconButton(
                        Icons.forward_10_rounded,
                        () async => await _asp.audioPlayerHandler.seek(
                            _asp.playbackState!.position +
                                const Duration(seconds: 10)),
                        isImage: false,
                        size: 28),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _iconButton(
                      Icons.skip_previous_rounded,
                      _asp.audioPlayer.hasPrevious
                          ? _asp.audioPlayerHandler.skipToPrevious
                          : () {},
                      color: _asp.audioPlayer.hasPrevious
                          ? Colors.white
                          : Colors.white38,
                      isImage: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GestureDetector(
                      child: CircleAvatar(
                          maxRadius: 32,
                          backgroundColor: playbackState.playing
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                          child: playbackState.playing
                              ? _iconButton(Icons.pause_rounded, () {
                                  _asp.audioPlayerHandler.pause();
                                  animationController.reset();
                                  animationController.stop();
                                }, isImage: false)
                              : playbackState.processingState ==
                                      AudioProcessingState.completed
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SizedBox.square(
                                        dimension: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                        ),
                                      ),
                                    )
                                  : _iconButton(Icons.play_arrow_rounded, () {
                                      _asp.audioPlayerHandler.play();
                                      animationController.repeat();
                                    }, isImage: false)),
                    ),
                  ),
                  _iconButton(
                      Icons.skip_next_rounded,
                      _asp.audioPlayer.hasNext
                          ? _asp.audioPlayerHandler.skipToNext
                          : () {},
                      color: _asp.audioPlayer.hasNext
                          ? Colors.white
                          : Colors.white38,
                      isImage: false),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
