import 'package:flutter/material.dart';
import 'package:melody/logic/blocs/google_auth/googleauth_cubit.dart';
import 'handlerscreen.dart';
import '../screen/authorizationPendingScreen.dart';
import '/logic/objects/user.dart';
import 'package:provider/provider.dart';

class SwitchScreen extends StatelessWidget {
  final User user;
  const SwitchScreen(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<GoogleAuthCubit>().setUser(user);

    return user.authorization
        ? const HandlerScreen()
        : const AuthorizationPendingScreen();
  }
}
