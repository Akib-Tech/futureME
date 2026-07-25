import 'package:flutter/material.dart';
import 'package:futureme/shared/widgets/link_text.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

/// Extracted from the duplicated Google/Apple blocks in login.dart.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({super.key, required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      contents: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 8),
            LinkText(content: label, shrinkWrap: true),
          ],
        ),
      ],
    );
  }
}
