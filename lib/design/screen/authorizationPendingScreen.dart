import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import 'package:provider/provider.dart';

class AuthorizationPendingScreen extends StatelessWidget {
  const AuthorizationPendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff000087), Color(0xff0000BA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        )),
        Positioned(
          top: -MediaQuery.of(context).size.width / 3.72,
          child: Image.asset('assets/images/design.png',
              width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
        ),
        Center(
            child: Lottie.asset('assets/images/floatingman.json',
                width: MediaQuery.of(context).size.width * 0.70,
                fit: BoxFit.fitWidth,
                repeat: true)),
        Positioned(
            left: 8,
            top: 32,
            child: TextButton.icon(
                onPressed: context.read<GoogleAuthCubit>().signOut,
                style: TextButton.styleFrom(primary: Colors.black54),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'))),
        Positioned(
          bottom: kToolbarHeight,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'Coming Soon!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
                child: Text(
                  'Dear user after sign In you might have to wait up to 24 hours '
                  'for verification to be available for a new Melody account. '
                  'I appreciate your patience while i work through this.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Image.asset(
                    'assets/images/exit.png',
                    height: 52,
                    fit: BoxFit.fitHeight,
                  ))
            ],
          ),
        ),
      ],
    ));
  }
}
