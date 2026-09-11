import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/subscription/subscription_service.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/paywall/failed_payment.dart';
import 'package:futureme/feature/paywall/success_payment.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/link_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

class PricingPackage extends StatefulWidget {
  const PricingPackage({super.key});

  @override
  State<PricingPackage> createState() => PricingPackageState();
}

class PricingPackageState extends State<PricingPackage> {
  static const _features = ["5 module FutureMe", "Chat AI cu ghidare personalizată", "3 evaluări / lună", "Raport PDF + audio final"];

  Package? _monthlyPackage;
  bool _isPurchasing = false;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _loadOffering();
  }

  Future<void> _loadOffering() async {
    final offering = await getIt<SubscriptionService>().getCurrentOffering();
    final package = offering?.monthly ?? offering?.availablePackages.firstOrNull;
    if (mounted) setState(() => _monthlyPackage = package);
  }

  void goToNextPage(Widget? nextPage) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage!));
  }

  Future<void> _continueWithMonthlyPlan() async {
    if (_isPurchasing || _isRestoring) return;
    setState(() => _isPurchasing = true);
    try {
      final uid = getIt<AuthService>().currentUser?.uid;
      final subscriptionService = getIt<SubscriptionService>();
      final package = _monthlyPackage;

      if (subscriptionService.isAvailable && package != null) {
        await subscriptionService.purchasePackage(package);
        if (uid != null) {
          await getIt<UserRepository>().recordVerifiedPurchase(uid, plan: 'monthly');
        }
      } else {
        // RevenueCat not configured yet (see RevenueCatConfig) — fall back
        // to the old unverified flag so the flow stays testable.
        if (uid != null) {
          await getIt<UserRepository>().recordSubscriptionSelection(uid, plan: 'monthly');
        }
      }
      if (!mounted) return;
      goToNextPage(SuccessPayment());
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.purchaseCancelledError) return;
      if (!mounted) return;
      goToNextPage(FailedPayment());
    } catch (_) {
      if (!mounted) return;
      goToNextPage(FailedPayment());
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _restorePurchases() async {
    if (_isPurchasing || _isRestoring) return;
    setState(() => _isRestoring = true);
    try {
      final isActive = await getIt<SubscriptionService>().restorePurchases();
      if (!mounted) return;
      if (isActive) {
        final uid = getIt<AuthService>().currentUser?.uid;
        if (uid != null) {
          await getIt<UserRepository>().recordVerifiedPurchase(uid, plan: 'monthly');
        }
        goToNextPage(SuccessPayment());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nu am găsit niciun abonament activ pentru acest cont.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: AppColors.background),
          child: Column(
            children: [
              CustomAppBar(context),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    PageTitle(content: "Activează experiența FutureMe"),
                    SizedBox(height: 16),
                    CenterText(content: "Planul include experiența FutureMe completă: modulele ghidate, raportul personalizat și audio-ul final."),
                    SizedBox(height: 24),
                    _MonthlyPlanCard(features: _features, priceText: _monthlyPackage?.storeProduct.priceString),
                    SizedBox(height: 24),
                    PrimaryButton(
                      content: _isPurchasing ? "Se procesează..." : "Continuă cu planul lunar",
                      onpressed: (_isPurchasing || _isRestoring) ? null : _continueWithMonthlyPlan,
                    ),
                    SizedBox(height: 16),
                    LinkText(
                      content: _isRestoring ? "Se restaurează..." : "Restaurează achizițiile",
                      onTap: (_isPurchasing || _isRestoring) ? null : _restorePurchases,
                    ),
                    SizedBox(height: 16),
                    CenterText(content: "Plata este securizată prin magazinul aplicației (App Store / Google Play). Abonamentul se reînnoiește automat și poate fi gestionat oricând."),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.grad1)),
            child: const Icon(Icons.check, size: 10, color: AppColors.grad1),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: AppColors.dashboard, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _MonthlyPlanCard extends StatelessWidget {
  const _MonthlyPlanCard({required this.features, this.priceText});

  final List<String> features;

  /// The store's localized price (e.g. "29,90 lei"), once the RevenueCat
  /// offering has loaded. Falls back to placeholder copy until then / when
  /// RevenueCat isn't configured yet.
  final String? priceText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plan lunar",
            style: TextStyle(color: AppColors.uiHeading, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.2),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText ?? "29,9",
                style: const TextStyle(color: AppColors.grad1, fontSize: 28, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.21),
              ),
              if (priceText == null) ...[
                const SizedBox(width: 4),
                const Text(
                  "lei/lună",
                  style: TextStyle(color: AppColors.dashboard, fontSize: 18, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.56),
                ),
              ],
            ],
          ),
          const Text(
            "Acces complet, cu plată lunară.",
            style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1, thickness: 1),
          const SizedBox(height: 8),
          for (final f in features) _FeatureRow(text: f),
        ],
      ),
    );
  }
}
