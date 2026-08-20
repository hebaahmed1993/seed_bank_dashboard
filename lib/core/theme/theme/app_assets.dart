import 'package:flutter/material.dart';

class AppAssets {
  static Widget appLogo({double size = 80.0}) {
    return Text(
      '🌱',
      style: TextStyle(fontSize: size),
    );

    // ملاحظة مستقبليّة: إذا أردتِ استبدالها بصورة PNG أو كود Vector،
    // كل ما عليكِ فعله هو تبديل النص أعلاه بـ:
    // return Image.asset('assets/images/logo.png', height: size, width: size);
  }
}