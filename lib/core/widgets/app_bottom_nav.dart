import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: scheme.shadow.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: onTabChange,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: scheme.surface,
            color: scheme.onSurfaceVariant,
            activeColor: scheme.onPrimaryContainer,
            tabBackgroundColor: scheme.primaryContainer,
            duration: const Duration(milliseconds: 300),
            tabs: [
              GButton(icon: Icons.dashboard_rounded, text: 'nav_home'.tr),
              GButton(icon: Icons.receipt_long_rounded, text: 'nav_transactions'.tr),
              GButton(icon: Icons.settings_rounded, text: 'nav_settings'.tr),
            ],
          ),
        ),
      ),
    );
  }
}