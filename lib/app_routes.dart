import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/design/screen/musicPlayingScreen.dart';
import 'package:melody/design/screen/noInternetScreen.dart';
import 'package:melody/design/screen/settingScreen.dart';
import 'package:melody/design/widget/commonWidgets.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import 'package:melody/logic/blocs/internetconnectivity_cubit/internet_cubit.dart';
import 'design/handler/switchscreen.dart';
import 'design/screen/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logic/objects/user.dart';

abstract class AppRoutes {
  static BlocListener<InternetCubit, InternetState> netListener(child) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetDisconnected) {
          showSnackBar(context, 'No internet Connection', seconds: 5);
          if (context.read<AudioCubit>().audioPlayer.playing) {
            context.read<AudioCubit>().audioPlayerHandler.pause();
          }
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }

  static Map<String, Widget Function(BuildContext)> routes = {
    '/404_screen': (context) => const NoInternetScreen(),
    '/music_playing_screen': (context) =>
        netListener(const MusicPlayingScreen()),
    '/setting_screen': (context) => netListener(const SettingScreen()),
    '/': (context) => BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            return state is InternetDisconnected
                ? const NoInternetScreen()
                : Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff000087), Color(0xff0000BA)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: BlocBuilder<GoogleAuthCubit, GoogleAuthState>(
                        builder: (context, state) {
                      if (state is GoogleAuthSignIn) {
                        return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(state.user.userId)
                                .snapshots(),
                            builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) =>
                                (snapshot.data?.exists ?? false)
                                    ? SwitchScreen(User.fromJson(
                                        Map<String, dynamic>.from(
                                            snapshot.data!.data()! as dynamic)))
                                    : const Center(
                                        child: CircularProgressIndicator()));
                      } else if (state is GoogleAuthError) {
                        return const NoInternetScreen();
                      } else if (state is GoogleAuthSignOut) {
                        return const LoginScreen();
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                  );
          },
        ),
  };
}
