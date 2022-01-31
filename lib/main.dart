// ignore_for_file: avoid_print
import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melody/app_routes.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import 'package:melody/logic/blocs/usercache_cubit/usercache_cubit.dart';
import 'package:melody/logic/repo/database.dart';
import '/logic/blocs/apptheme_cubit/apptheme_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'logic/blocs/internetconnectivity_cubit/internet_cubit.dart';
import 'logic/repo/themeData.dart';
import 'logic/service/audioPlayerHandler.dart';

Future<HydratedStorage> mainNativeInitialization() async {
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return storage;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedStorage storage = await mainNativeInitialization();
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayerHandler _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandlerImpl(_player),
      config: const AudioServiceConfig(
          androidNotificationChannelId:
              'com.rahulsharmadev.melody.channel.audio',
          androidNotificationChannelName: 'Melody audio playback'));
  HydratedBlocOverrides.runZoned(
      () => runApp(
            MultiBlocProvider(
                providers: [
                  BlocProvider<AudioCubit>(
                      create: (_ctx) => AudioCubit(_audioHandler, _player)),
                  BlocProvider<AppthemeCubit>(
                      create: (_ctx) => AppthemeCubit()),
                  BlocProvider<UserCacheCubit>(
                      create: (_ctx) => UserCacheCubit()),
                  BlocProvider<InternetCubit>(
                      create: (_ctx) => InternetCubit()),
                  BlocProvider<GoogleAuthCubit>(
                      create: (_ctx) => GoogleAuthCubit()),
                ],
                child: ChangeNotifierProvider(
                  create: (context) => Database(),
                  builder: (_ctx, child) => const MyAppSetup(),
                )),
          ),
      storage: storage);
}

class MyAppSetup extends StatelessWidget {
  const MyAppSetup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(context.read<UserCacheCubit>().state.availableSongs.length);
    return BlocBuilder<AppthemeCubit, int>(
        builder: (context, index) => MaterialApp(
            title: 'Melody',
            theme: MyTheme.list[index].themeData,
            themeMode: ThemeMode.dark,
            routes: AppRoutes.routes,
            initialRoute: '/'));
  }
}
