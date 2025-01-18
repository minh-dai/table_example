import 'dart:math';
import 'dart:ui';

import 'model/work_site.dart';

class AppColors {
  static const teal = Color(0xff3BDBD3);
  static const lightGreen = Color(0xff60E487);
  static const skyBlue = Color(0xff61B4F2);
  static const aquaBlue = Color(0xff6CFAFA);
  static const purple = Color(0xff803BFF);
  static const lightBlue = Color(0xff98BFFF);
  static const limeGreen = Color(0xffB4EC4C);
  static const greyBlue = Color(0xffC3CED4);
  static const mintGreen = Color(0xffD4EFDF);
  static const lavender = Color(0xffDDC5E5);
  static const pinkishWhite = Color(0xffF5EEF8);
  static const yellow = Color(0xffF7DC6F);
  static const softPink = Color(0xffFADBD8);
  static const brightPink = Color(0xffFF58CD);
  static const coralRed = Color(0xffFF6860);
  static const orange = Color(0xffFF7337);
  static const peach = Color(0xffFFA16B);
  static const lightCream = Color(0xffFFF3E0);

  // color border list
  static const borderColor = Color(0xff686868);


  List<Color> get allColors => [
        teal,
        lightGreen,
        skyBlue,
        aquaBlue,
        purple,
        lightBlue,
        limeGreen,
        greyBlue,
        mintGreen,
        lavender,
        pinkishWhite,
        yellow,
        softPink,
        brightPink,
        coralRed,
        orange,
        peach,
        lightCream,
      ];

  Color getRandomColorExcludingSelected(List<WorkSite> workSites) {
    final colors = AppColors().allColors;
    final selectedColors = workSites.map((ws) => ws.color).toSet();
    final availableColors =
        colors.where((color) => !selectedColors.contains(color)).toList();

    final random = Random();
    if (availableColors.isEmpty) {
      return colors[random.nextInt(colors.length)];
    }

    return availableColors[random.nextInt(availableColors.length)];
  }
}
