import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';

class LinkText extends StatelessWidget {
  const LinkText({super.key, this.content, this.fontSize, this.shrinkWrap = false});

  final String? content;
  final double? fontSize;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return LeftLightText(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w500,
      content: content ?? "",
      color: AppColors.grad1 /* ui-action-secondaryText */,
      shrinkWrap: shrinkWrap,
    );
  }
}
