import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

class LeftLightText extends StatelessWidget {
  const LeftLightText({
    super.key,
    this.content,
    this.width,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.textAlign,
  });

  final String? content;
  final double? width;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 345,
      child: Text(
        content ?? "",
        textAlign: textAlign ?? TextAlign.left,
        style: TextStyle(
          color: color ?? AppColors.uiHeadingSmall /* ui-text-secondary */,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? AppFonts.body,
          fontWeight: fontWeight ?? FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.16,
        ),
      ),
    );
  }
}
