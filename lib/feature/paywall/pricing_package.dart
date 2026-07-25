import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/paywall/success_payment.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

enum _Plan { annual, monthly }

class PricingPackage extends StatefulWidget {
  const PricingPackage({super.key});

  @override
  State<PricingPackage> createState() => PricingPackageState();
}

class PricingPackageState extends State<PricingPackage> {
  _Plan _selected = _Plan.annual;

  void goToNextPage(Widget? nextPage) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage!));
  }

  static const _features = ["5 module FutureMe", "Chat AI cu ghidare personalizată", "3 evaluări / lună", "Raport PDF + audio final"];

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
                    PageTitle(content: "Alege planul potrivit pentru tine"),
                    SizedBox(height: 16),
                    CenterText(content: "Ambele planuri includ experiența FutureMe completă: modulele ghidate, raportul personalizat și audio-ul final."),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => setState(() => _selected = _Plan.annual),
                      child: _AnnualPlanCard(selected: _selected == _Plan.annual, features: _features),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => _selected = _Plan.monthly),
                      child: _MonthlyPlanCard(selected: _selected == _Plan.monthly, features: _features),
                    ),
                    SizedBox(height: 24),
                    PrimaryButton(
                      content: _selected == _Plan.annual ? "Continuă cu planul anual" : "Continuă cu planul lunar",
                      onpressed: () {
                        goToNextPage(SuccessPayment());
                      },
                    ),
                    SizedBox(height: 16),
                    CenterText(content: "Plata este securizată prin magazinul aplicației. Abonamentul se reînnoiește automat și poate fi gestionat oricând."),
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

class _PlanRadio extends StatelessWidget {
  const _PlanRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.grad1 : null,
        border: selected ? null : Border.all(color: AppColors.border, width: 2),
      ),
      child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
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

class _AnnualPlanCard extends StatelessWidget {
  const _AnnualPlanCard({required this.selected, required this.features});

  final bool selected;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: AppColors.grad1), borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: const BoxDecoration(
              color: AppColors.faint,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHighlight,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: const Text(
                        "Recomandat · 2 luni gratuite",
                        style: TextStyle(color: AppColors.dashboard, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.33),
                      ),
                    ),
                    _PlanRadio(selected: selected),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Plan anual",
                  style: TextStyle(color: AppColors.uiHeading, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.2),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "299",
                      style: TextStyle(color: AppColors.grad1, fontSize: 28, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.21),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "lei/an",
                      style: TextStyle(color: AppColors.dashboard, fontSize: 18, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.56),
                    ),
                  ],
                ),
                const Text(
                  "Economisești și primești acces la resurse bonus.",
                  style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                ),
                const SizedBox(height: 16),
                Divider(color: AppColors.border, height: 1, thickness: 1),
                const SizedBox(height: 8),
                for (final f in features) _FeatureRow(text: f),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.faint,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
            ),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard_outlined, color: AppColors.uiHeading),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Biblioteca de resurse bonus inclusă",
                    style: TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
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

class _MonthlyPlanCard extends StatelessWidget {
  const _MonthlyPlanCard({required this.selected, required this.features});

  final bool selected;
  final List<String> features;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Plan lunar",
                    style: TextStyle(color: AppColors.uiHeading, fontSize: 20, fontFamily: AppFonts.heading, fontWeight: FontWeight.w500, height: 1.2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "29,9",
                        style: TextStyle(color: AppColors.grad1, fontSize: 28, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.21),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "lei/lună",
                        style: TextStyle(color: AppColors.dashboard, fontSize: 18, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.56),
                      ),
                    ],
                  ),
                  const Text(
                    "Acces complet, cu plată lunară.",
                    style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 12, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                  ),
                ],
              ),
              _PlanRadio(selected: selected),
            ],
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
