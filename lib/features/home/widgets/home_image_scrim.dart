import 'package:flutter/material.dart';

/// White scrim used behind text overlaid on a card image — fades from
/// transparent at the top to fully white at the bottom so dark text on the
/// lower portion of the card stays legible.
class HomeImageScrim extends StatelessWidget {
  const HomeImageScrim({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00FFFFFF),
            Color(0xD9FFFFFF),
            Color(0xFFFFFFFF),
          ],
          stops: [0.40, 0.58, 0.72],
        ),
      ),
    );
  }
}
