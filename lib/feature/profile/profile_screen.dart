import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/authentication/reset_password_screen.dart';
import 'package:futureme/feature/chat/chat_flow.dart';
import 'package:futureme/feature/dashboard/dashboard_navigation.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:futureme/feature/report/report_screen.dart';
import 'package:futureme/feature/resources/resources_screen.dart';
import 'package:futureme/shared/widgets/app_bottom_nav_bar.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = getIt<AuthService>().currentUser?.uid;
    await ModuleProgress.hydrate();
    Map<String, dynamic>? profile;
    if (uid != null) {
      try {
        profile = await getIt<UserRepository>().fetchProfile(uid);
      } catch (_) {
        profile = null;
      }
    }
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    try {
      await getIt<AuthService>().signOut();
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nu am putut ieși din cont. Încearcă din nou.')),
      );
      setState(() => _signingOut = false);
    }
  }

  bool get _subscriptionActive {
    final status = (_profile?['subscription'] as Map<String, dynamic>?)?['status'] as String?;
    return status != null && status.startsWith('active');
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthService>().currentUser;
    final name = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : ((_profile?['displayName'] as String?)?.trim().isNotEmpty ?? false)
            ? (_profile!['displayName'] as String).trim()
            : "Contul tău";
    final email = user?.email ?? (_profile?['email'] as String?) ?? "—";
    final completed = ModuleProgress.completedModules.clamp(0, 5);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNavBar(
        activeIndex: 4,
        onHomeTap: () => goToDashboard(context),
        onChatTap: () => openChat(context, contextLabel: "Raportul tău · Repere de până acum"),
        onReportTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReportScreen()),
        ),
        onResourcesTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResourcesScreen()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(context),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const PageTitle(content: "Profilul tău", textAlign: TextAlign.left),
                          const SizedBox(height: 24),
                          _IdentityCard(name: name, email: email),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: "Parcursul tău",
                            body: "$completed din 5 module finalizate",
                            progress: completed / 5,
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: "Abonament",
                            body: _subscriptionActive
                                ? "Plan lunar · activ"
                                : "Niciun abonament activ",
                          ),
                          const SizedBox(height: 24),
                          _ActionRow(
                            icon: Icons.lock_outline,
                            label: "Schimbă parola",
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                            ),
                          ),
                          const Divider(color: AppColors.border, height: 1),
                          _ActionRow(
                            icon: Icons.logout,
                            label: _signingOut ? "Se deconectează..." : "Deconectează-te",
                            onTap: _signingOut ? null : _signOut,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.faint,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.specialGradient),
            child: Text(
              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "?",
              style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: AppColors.uiHeading, fontSize: 18, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.25),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body, this.progress});

  final String title;
  final String body;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(color: AppColors.dashboard, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.statusInfoFg),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.dashboard),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: AppColors.dashboard, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.uiHeadingSmall),
          ],
        ),
      ),
    );
  }
}
