// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/audioservice_cubit/audio_cubit.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import 'package:melody/logic/blocs/usercache_cubit/usercache_cubit.dart';
import 'package:melody/logic/repo/database.dart';
import '/logic/blocs/apptheme_cubit/apptheme_cubit.dart';
import '/logic/repo/themeData.dart';
import '/logic/service/iScaffold.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future<void> _urlLaunch(String url) async {
    try {
      await launch(url);
    } catch (error) {
      Exception('Error: $url $error');
    }
  }

  tile(
          {required String title,
          required String icon,
          required String description,
          Widget? trailing,
          VoidCallback? onTap}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          dense: true,
          horizontalTitleGap: 8,
          minVerticalPadding: 12,
          tileColor: Colors.black38,
          onTap: onTap,
          leading: Image.asset(
            icon,
            width: 32,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            description,
          ),
          trailing: trailing,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return IScafford(
      appBar: AppBar(
          automaticallyImplyLeading: false, actions: const [CloseButton()]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl:
                      context.read<GoogleAuthCubit>().state.user.profilePic,
                  width: 120,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.read<GoogleAuthCubit>().state.user.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 32),
              tile(
                icon: 'assets/icons/autoplay.png',
                title: 'Autoplay',
                description:
                    'Keep on listening to similar tracks when your music ends.',
                trailing: BlocBuilder<UserCacheCubit, UserCache>(
                  builder: (context, state) {
                    return Switch(
                        value: state.autoPlay,
                        onChanged: (value) =>
                            context.read<UserCacheCubit>().emitAutoplay(value));
                  },
                ),
              ),
              tile(
                icon: 'assets/icons/gapless.png',
                title: 'Gapless Playback',
                description:
                    'Switch ON to play songs one after another, without break.',
                trailing: BlocBuilder<UserCacheCubit, UserCache>(
                  builder: (context, state) {
                    return Switch(
                        value: state.gapless,
                        onChanged: (value) =>
                            context.read<UserCacheCubit>().emitGapless(value));
                  },
                ),
              ),
              tile(
                icon: 'assets/icons/savemode.png',
                title: 'Data Save Mode',
                description:
                    'Save 70% of your data by adjusting the songs quality and images.',
                trailing: BlocBuilder<UserCacheCubit, UserCache>(
                  builder: (context, state) {
                    return Switch(
                        value: state.dataSaveMode,
                        onChanged: (value) => context
                            .read<UserCacheCubit>()
                            .emitDataSaveMode(value));
                  },
                ),
              ),
              tile(
                  icon: 'assets/icons/theme.png',
                  title: 'App Theme',
                  description:
                      'Select a theme of your choice throughout the app.',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (builder) => const AppThemeDialog());
                  }),
              tile(
                icon: 'assets/icons/policy.png',
                title: 'Privacy Policy',
                description: 'Important for both of us.',
                onTap: () => _urlLaunch(
                    'https://www.privacypolicies.com/live/ed5a7f05-8d0f-48dc-ab97-954c0e794f0b'),
              ),
              tile(
                  icon: 'assets/icons/tc.png',
                  title: 'Terms and Conditions',
                  description: 'Important for both of us.',
                  onTap: () => _urlLaunch(
                      'https://www.privacypolicies.com/live/46a3442c-05cd-4af3-91c6-484b54f0e20c')),
              tile(
                  icon: 'assets/icons/logout.png',
                  title: 'Log out',
                  description: 'You are logged out.',
                  onTap: () async {
                    context.read<AudioCubit>().audioPlayerHandler.stop();
                    await context.read<GoogleAuthCubit>().signOut();
                    Navigator.pop(context);
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                    child: Text('Delete Account',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.red, fontWeight: FontWeight.w600)),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(
                              context.read<GoogleAuthCubit>().state.user.userId)
                          .update({"authorization": false});
                      context.read<AudioCubit>().audioPlayerHandler.stop();
                      await context.read<GoogleAuthCubit>().disconnect();
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppThemeDialog extends StatelessWidget {
  const AppThemeDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const ListTile(
          tileColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          title: Text('App Theme'),
          trailing: CloseButton(
            color: Colors.white,
          ),
        ),
        content: SizedBox(
          height: 350,
          child: Column(
              children: List.generate(
            MyTheme.list.length,
            (index) => InkResponse(
              onTap: () => context.read<AppthemeCubit>().setApptheme(index),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (index == context.read<AppthemeCubit>().state)
                      Text(
                        'Active',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(MyTheme.list[index].title)),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(MyTheme.list[index].backgroundImg))),
              ),
            ),
          )),
        ));
  }
}
