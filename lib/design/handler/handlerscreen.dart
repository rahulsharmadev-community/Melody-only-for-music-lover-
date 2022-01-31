import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import '../screen/home.dart';
import '../screen/musicPlayingScreen.dart';
import '../screen/search.dart';
import '../screen/settingScreen.dart';
import '/logic/service/iScaffold.dart';
import '../widget/botomSeekWidget.dart';

class HandlerScreen extends StatefulWidget {
  const HandlerScreen({Key? key}) : super(key: key);

  @override
  _HandlerScreenState createState() => _HandlerScreenState();
}

class _HandlerScreenState extends State<HandlerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var navigationItems = [
    {
      'title': 'Home',
      'activeIcon': Icons.home_rounded,
      'inActiveIcon': Icons.home_outlined
    },
    {
      'title': 'Search',
      'activeIcon': Icons.search_rounded,
      'inActiveIcon': Icons.search_rounded
    },
    // {
    //   'title': 'Playlists',
    //   'activeIcon': Icons.queue_music_outlined,
    //   'inActiveIcon': Icons.queue_music_outlined
    // },
    // {
    //   'title': 'Premium',
    //   'activeIcon': Icons.public_outlined,
    //   'inActiveIcon': Icons.vpn_lock_outlined
    // }
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return IScafford(
          appBar: AppBar(
            toolbarHeight: kToolbarHeight * 1.5,
            title: RichText(
                strutStyle: const StrutStyle(height: 2),
                text: TextSpan(
                    text: 'Hi',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w200),
                    children: [
                      TextSpan(
                        text:
                            ' ${context.read<GoogleAuthCubit>().state.user.name.split(' ')[0]}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(
                        text: '\nWelcome back!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      )
                    ])),
            actions: [
              IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/setting_screen'),
                  icon: const Icon(
                    Icons.settings_suggest_rounded,
                    size: 30,
                  ))
            ],
            centerTitle: false,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state.playbackState!.processingState !=
                  AudioProcessingState.idle
              ? GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/music_playing_screen'),
                  child:
                      BottomSeekWidget(audiohandler: state.audioPlayerHandler))
              : null,
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (value) => setState(() => currentIndex = value),
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              items: navigationItems
                  .map((e) => BottomNavigationBarItem(
                      label: e['title'] as String,
                      icon: Icon(e['inActiveIcon'] as IconData),
                      activeIcon: Icon(e['activeIcon'] as IconData)))
                  .toList()),
          body: currentIndex == 0 ? const Home() : const Search(),
        );
      },
    );
  }
}
