import 'package:flutter/material.dart';
import 'package:futureme/core/audio/tts_service.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

/// A real audio-message card: tapping play speaks [spokenText] aloud with
/// on-device text-to-speech and tapping it again stops playback. Replaces
/// the earlier cards that only toggled a play/pause icon over a decorative,
/// non-functional waveform without ever producing sound.
class TtsAudioCard extends StatefulWidget {
  const TtsAudioCard({super.key, required this.title, required this.subtitle, required this.spokenText});

  final String title;
  final String subtitle;
  final String spokenText;

  @override
  State<TtsAudioCard> createState() => _TtsAudioCardState();
}

class _TtsAudioCardState extends State<TtsAudioCard> {
  bool _speaking = false;

  Future<void> _toggle() async {
    final tts = getIt<TtsService>();
    if (_speaking) {
      await tts.stop();
      if (mounted) setState(() => _speaking = false);
      return;
    }
    setState(() => _speaking = true);
    await tts.speak(widget.spokenText);
    if (mounted) setState(() => _speaking = false);
  }

  @override
  void dispose() {
    if (_speaking) getIt<TtsService>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(color: AppColors.uiHeading, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w500, height: 1.375),
          ),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.faint, borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggle,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(gradient: AppColors.specialGradient, shape: BoxShape.circle),
                    child: Icon(_speaking ? Icons.stop : Icons.play_arrow, size: 14, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _speaking ? "Se redă..." : "Apasă pentru a asculta",
                    style: const TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
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
