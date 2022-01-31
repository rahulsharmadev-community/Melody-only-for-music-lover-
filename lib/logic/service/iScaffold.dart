import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody/logic/blocs/apptheme_cubit/apptheme_cubit.dart';
import 'package:melody/logic/repo/themeData.dart';

class IScafford extends StatelessWidget {
  final double blur;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  const IScafford({
    Key? key,
    this.blur = 1.0,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
  })  : assert(primary != null),
        assert(extendBody != null),
        assert(extendBodyBehindAppBar != null),
        assert(drawerDragStartBehavior != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppthemeCubit, int>(
      builder: (context, int index) => Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(MyTheme.list[index].backgroundImg),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Scaffold(
                key: key,
                backgroundColor: Colors.transparent,
                drawerScrimColor: Colors.transparent,
                bottomNavigationBar: bottomNavigationBar,
                appBar: appBar,
                body: body,
                bottomSheet: bottomSheet,
                extendBody: extendBody,
                drawer: drawer,
                drawerDragStartBehavior: drawerDragStartBehavior,
                drawerEdgeDragWidth: drawerEdgeDragWidth,
                endDrawer: endDrawer,
                floatingActionButton: floatingActionButton,
                floatingActionButtonAnimator: floatingActionButtonAnimator,
                floatingActionButtonLocation: floatingActionButtonLocation,
                extendBodyBehindAppBar: extendBodyBehindAppBar,
                drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
                endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
                onEndDrawerChanged: onEndDrawerChanged,
                onDrawerChanged: onDrawerChanged,
                persistentFooterButtons: persistentFooterButtons,
                primary: primary,
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                restorationId: restorationId,
              ))),
    );
  }
}
