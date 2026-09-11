import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';

/// Reads module feedback/messages aloud with the device's on-device text-to-
/// speech engine — no audio files, no backend, no API key. Replaces the
/// old play/pause buttons that only toggled an icon without ever producing
/// sound.
@lazySingleton
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) return;
    await _tts.setLanguage('ro-RO');
    await _tts.awaitSpeakCompletion(true);
    _ready = true;
  }

  /// Speaks [text] aloud. Completes once speech finishes, or immediately
  /// once [stop] is called from elsewhere.
  Future<void> speak(String text) async {
    await _ensureReady();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
