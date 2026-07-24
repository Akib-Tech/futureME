import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';

class IconDivider extends StatelessWidget {
  const IconDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFFE9DCD7) /* ui-border-default */,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 16,
            height: 16,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Stack(
              children: [
                Image.asset(AppAssets.loveIcon),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFFE9DCD7) /* ui-border-default */,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
