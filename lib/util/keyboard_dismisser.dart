import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardDismisser extends StatelessWidget {
  final Widget child;

  const KeyboardDismisser({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
   
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}


class KeyboardDismissRouteObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
  
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
   
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

