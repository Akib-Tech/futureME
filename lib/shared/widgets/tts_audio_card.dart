import 'package:flutter/material.dart';
import 'package:futureme/core/audio/tts_service.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:just_audio/just_audio.dart';

/// A real audio-message card. By default it speaks [spokenText] aloud with
/// on-device text-to-speech, since most modules' messages are written per
/// user and can't be pre-recorded. Pass [assetPath] where a recording does
/// exist and the card plays that file instead — a real voice beats TTS
/// wherever the words are the same for everyone.
///
/// Replaces the earlier cards that only toggled a play/pause icon over a
/// decorative, non-functional waveform without ever producing sound.
class TtsAudioCard extends StatefulWidget {
  const TtsAudioCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.spokenText,
    this.assetPath,
  });

  final String title;
  final String subtitle;

  /// Spoken by TTS when [assetPath] is null; ignored otherwise.
  final String spokenText;

  /// Optional pre-recorded clip, e.g. `assets/audio/module1_complete.m4a`.
  final String? assetPath;

  @override
  State<TtsAudioCard> createState() => _TtsAudioCardState();
}

class _TtsAudioCardState extends State<TtsAudioCard> with WidgetsBindingObserver {
  bool _playing = false;
  AudioPlayer? _player;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _toggle() async {
    if (widget.assetPath != null) {
      await _toggleRecording();
      return;
    }

    final tts = getIt<TtsService>();
    if (_playing) {
      await tts.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }
    setState(() => _playing = true);
    await tts.speak(widget.spokenText);
    if (mounted) setState(() => _playing = false);
  }

  Future<void> _toggleRecording() async {
    if (_playing) {
      await _player?.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }

    final player = _player ??= AudioPlayer();
    setState(() => _playing = true);
    try {
      await player.setAsset(widget.assetPath!);
      await player.play(); // completes when the clip finishes
    } catch (_) {
      // A missing or unplayable file shouldn't leave the card stuck on
      // "Se redă..." — fall back to showing it as stopped.
    }
    if (mounted) setState(() => _playing = false);
  }

  /// Stops whichever source is playing, without touching widget state —
  /// safe to call while the route is being torn down.
  void _stopPlayback() {
    if (!_playing) return;
    if (widget.assetPath != null) {
      _player?.stop();
    } else {
      getIt<TtsService>().stop();
    }
  }

  /// Continuing to the next module pushes a screen on top rather than
  /// replacing this one, so dispose never runs and the message kept
  /// playing over the pages that followed. Pausing when the app or route
  /// stops being visible stops the audio whichever way the user leaves.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _stopPlayback();
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  void deactivate() {
    _stopPlayback();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopPlayback();
    _player?.dispose();
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
                    child: Icon(_playing ? Icons.stop : Icons.play_arrow, size: 14, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _playing ? "Se redă..." : "Apasă pentru a asculta",
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