import 'dart:math';
import 'package:flutter/material.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:provider/provider.dart';

class SeekBar extends StatefulWidget {
  final double thumbRadius;
  final bool showDuration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    this.showDuration = false,
    this.thumbRadius = 6,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;
  SliderThemeData get _sliderThemeData => SliderTheme.of(context).copyWith(
        trackHeight: widget.thumbRadius / 2,
        thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: widget.thumbRadius),
        overlayShape:
            RoundSliderThumbShape(enabledThumbRadius: widget.thumbRadius * 2),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StreamData>(
        stream: context.read<AudioCubit>().audioPlayerStream,
        builder: (context, snapshot) {
          final position = snapshot.data?.position ?? Duration.zero;
          final duration = snapshot.data?.duration ?? Duration.zero;
          final bufferedPosition =
              snapshot.data?.bufferedPosition ?? Duration.zero;
          final value = min(
            _dragValue ?? position.inMilliseconds.toDouble(),
            duration.inMilliseconds.toDouble(),
          );

          if (_dragValue != null && !_dragging) {
            _dragValue = null;
          }
          Duration _remaining = duration - position;
          return SizedBox(
            height: widget.showDuration ? 40 : 14,
            width: double.maxFinite,
            child: Stack(
              children: [
                SliderTheme(
                  data: _sliderThemeData.copyWith(
                    thumbShape: HiddenThumbComponentShape(),
                  ),
                  child: ExcludeSemantics(
                    child: Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble(),
                      value: min(bufferedPosition.inMilliseconds.toDouble(),
                          duration.inMilliseconds.toDouble()),
                      onChanged: (value) {},
                    ),
                  ),
                ),
                SliderTheme(
                  data: _sliderThemeData,
                  child: Slider(
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    value: value,
                    onChanged: (value) {
                      if (!_dragging) {
                        _dragging = true;
                      }
                      setState(() {
                        _dragValue = value;
                      });
                      if (widget.onChanged != null) {
                        widget
                            .onChanged!(Duration(milliseconds: value.round()));
                      }
                    },
                    onChangeEnd: (value) {
                      if (widget.onChangeEnd != null) {
                        widget.onChangeEnd!(
                            Duration(milliseconds: value.round()));
                      }
                      _dragging = false;
                    },
                  ),
                ),
                if (widget.showDuration)
                  Positioned(
                    bottom: 0.0,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Text(
                            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                    .firstMatch("$position")
                                    ?.group(1) ??
                                '$position',
                            style: Theme.of(context).textTheme.caption),
                        const Spacer(),
                        Text(
                            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                    .firstMatch("$_remaining")
                                    ?.group(1) ??
                                '$_remaining',
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}
