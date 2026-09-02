import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_colors.dart';

class SpinLoader {
  static Widget loader({Color color = AppColors.primary, double size = 60.0}) {
    return Center(
      child: SpinKitFadingFour(color: color, size: size),
    );
  }
}
