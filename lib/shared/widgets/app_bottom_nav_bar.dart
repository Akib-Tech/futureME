import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// Figma "Action Buttons" (dashboard bottom bar, e.g. frame 61:271, also
/// reused on the Chat screens) — a custom icon+label row, not a standard
/// Material BottomNavigationBar. Only "Acasă" and "Chat" are wired to real
/// screens; Raport, Resurse and Profil don't have screens built yet, so
/// they're inert placeholders for now.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, this.activeIndex = 0, this.onHomeTap, this.onChatTap});

  /// Which item is highlighted (0 = Acasă, 1 = Chat).
  final int activeIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onChatTap;

  static const _items = [
    (icon: Icons.home_outlined, label: "Acasă"),
    (icon: Icons.chat_bubble_outline, label: "Chat"),
    (icon: Icons.description_outlined, label: "Raport"),
    (icon: Icons.menu_book_outlined, label: "Resurse"),
    (icon: Icons.person_outline, label: "Profil"),
  ];

  @override
  Widget build(BuildContext context) {
    final taps = [onHomeTap, onChatTap, null, null, null];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Color(0x0D251006), blurRadius: 12, offset: Offset(0, -6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < _items.length; i++)
            GestureDetector(
              onTap: taps[i],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_items[i].icon, size: 24, color: i == activeIndex ? AppColors.grad1 : AppColors.uiHeadingSmall),
                  const SizedBox(height: 4),
                  Text(
                    _items[i].label,
                    style: TextStyle(
                      color: i == activeIndex ? AppColors.grad1 : AppColors.uiHeadingSmall,
                      fontSize: 13,
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w500,
                      height: 1.23,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
