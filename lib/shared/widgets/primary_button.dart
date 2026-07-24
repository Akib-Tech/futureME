import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.content,
    this.width,
    this.contentPadding,
    this.onpressed,
    this.color,
    this.borderRadius,
    this.fontSize,
    this.textColor,
  });

  final String? content;
  final double? width;
  final EdgeInsets? contentPadding;
  final VoidCallback? onpressed;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed ?? () {},
      child: Container(
        width: width ?? 345,
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: ShapeDecoration(
          color: color ?? const Color(0xFF2B0B78) /* ui-action-primary */,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              content ?? "",
              style: TextStyle(
                color: textColor ?? Colors.white /* ui-text-inverse */,
                fontSize: fontSize ?? 16,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
