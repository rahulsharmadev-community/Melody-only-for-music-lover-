// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:melody/logic/service/iScaffold.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IScafford(
      body: Center(
        child: LottieBuilder.asset(
          'assets/images/404.json',
          width: 300,
          fit: BoxFit.cover,
          repeat: true,
        ),
      ),
    );
  }
}
