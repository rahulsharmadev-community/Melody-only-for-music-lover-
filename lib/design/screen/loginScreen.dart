//ignore_for_file:file_names
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double designFromTop, floatingmanFromtop, siginLogoOpacity;
  late bool isSignInStep;
  late String button;

  void resetValue() {
    setState(() {
      siginLogoOpacity = designFromTop = 0;
      floatingmanFromtop = MediaQuery.of(context).size.height / 1.9;
      button = 'assets/images/continueButton.png';
      isSignInStep = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    resetValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              top: designFromTop,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCirc,
              child: Image.asset('assets/images/design.png',
                  width: MediaQuery.of(context).size.width),
            ),
            if (isSignInStep)
              Positioned(
                  left: 8,
                  top: 32,
                  child: TextButton.icon(
                      onPressed: resetValue,
                      style: TextButton.styleFrom(primary: Colors.black54),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'))),
            AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                left: 16,
                top: MediaQuery.of(context).size.height *
                    (isSignInStep ? 0.28 : 0.43),
                child: Image.asset(
                  'assets/images/welcome.png',
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.fitWidth,
                )),
            circularContainer(bottom: isSignInStep ? 50 : 10, right: 100),
            AnimatedPositioned(
                top: floatingmanFromtop,
                left: 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutSine,
                child: Lottie.asset('assets/images/floatingman.json',
                    width: MediaQuery.of(context).size.width * 0.70,
                    fit: BoxFit.fitWidth,
                    repeat: true)),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.19,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                  opacity: siginLogoOpacity,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/signInLogo.png',
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'After Sign In you might have to wait up to 24 hours for verification to be available for a new Melody account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  )),
            ),
            AnimatedPositioned(
              bottom: MediaQuery.of(context).size.height * 0.07,
              right: isSignInStep ? null : 16,
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              child: TextButton(
                  onPressed: () async {
                    if (!isSignInStep) {
                      setState(() {
                        designFromTop =
                            -MediaQuery.of(context).size.width / 3.72;
                        floatingmanFromtop =
                            MediaQuery.of(context).size.height / 3.0;
                        siginLogoOpacity = 1;
                        button = 'assets/images/signIn.png';
                        isSignInStep = true;
                      });
                    } else {
                      await context.read<GoogleAuthCubit>().signIn();
                    }
                  },
                  child: Image.asset(
                    button,
                    height: isSignInStep ? 56 : 38,
                    fit: BoxFit.fitHeight,
                  )),
            )
          ],
        ));
  }

  AnimatedPositioned circularContainer({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
  }) {
    return AnimatedPositioned(
      bottom: -(MediaQuery.of(context).size.width / 2) + bottom!,
      right: -(MediaQuery.of(context).size.width / 2) + right!,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: Container(
          constraints: BoxConstraints.loose(
              Size.fromRadius(MediaQuery.of(context).size.width / 2)),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width / 2),
            gradient: const LinearGradient(
              colors: [Color(0xff0000BC), Color(0xff000087)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          )),
    );
  }
}
