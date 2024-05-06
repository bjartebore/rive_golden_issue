import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    super.key,
    this.builder,
  });

  final WidgetBuilder? builder;

  @override
  State<BackgroundAnimation> createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<BackgroundAnimation> {
  void _onInit(Artboard art) {
    var ctrl = StateMachineController.fromArtboard(
      art,
      'state',
    ) as StateMachineController;

    art.addController(ctrl);
  }

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: RiveAnimation.asset(
                'assets/animations/test.riv',
                useArtboardSize: true,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
