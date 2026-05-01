// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SARLogo extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  const SARLogo({
    super.key,
    this.width = 15,
    this.height = 15,
    this.color = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/saudi_riyal.svg',
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
