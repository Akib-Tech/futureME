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
    this.gradient,
  });

  final String? content;
  final double? width;
  final EdgeInsets? contentPadding;
  final VoidCallback? onpressed;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final Color? textColor;

  /// Overrides [color] when set. Matches the design system's
  /// "Action/Special Gradient" token (#2b0b78 -> #7f378e -> #d35771).
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed ?? () {},
      child: Container(
        width: width ?? 345,
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: ShapeDecoration(
          color: gradient == null ? (color ?? const Color(0xFF2B0B78) /* ui-action-primary */) : null,
          gradient: gradient,
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
