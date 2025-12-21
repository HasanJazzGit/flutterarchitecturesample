import 'package:flutter/material.dart';

import '../../generated/assets.dart';


class AppLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const AppLogoWidget({
    super.key,
    this.width = 80, // default width
    this.height = 80, // default height
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesAppLogo,
      width: width,
      height: height,
    );
  }
}
