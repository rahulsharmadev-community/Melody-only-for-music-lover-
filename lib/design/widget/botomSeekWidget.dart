import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'commonWidgets.dart';
import 'seekBar.dart';

class BottomSeekWidget extends StatelessWidget {
  final AudioHandler audiohandler;
  const BottomSeekWidget({Key? key, required this.audiohandler})
      : super(key: key);
  Widget _iconButton(IconData iconData, VoidCallback onPressed) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          child: Icon(
            iconData,
            color: Colors.white,
            size: 24.0,
          ),
          onTap: onPressed,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, _asp) => Container(
        height: kToolbarHeight,
        width: MediaQuery.of(context).size.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.fill,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        audiohandler.mediaItem.value?.title ?? '',
                      ),
                    ),
                  )),
                  Row(
                    children: [
                      _iconButton(Icons.thumb_up_outlined, () {
                        showSnackBar(
                            context, 'Requested service not available.');
                      }),
                      if (audiohandler.playbackState.value.playing)
                        _iconButton(Icons.pause_rounded, audiohandler.pause)
                      else
                        _iconButton(
                            Icons.play_arrow_rounded, audiohandler.play),
                      _iconButton(
                          Icons.skip_next_rounded, audiohandler.skipToNext),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SeekBar(
                thumbRadius: 4,
                onChangeEnd: (newPosition) {
                  audiohandler.seek(newPosition);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
