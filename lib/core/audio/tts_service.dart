import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

/// Speaks module feedback in the app's own cloned voice: the text is sent to
/// the `synthesizeSpeech` callable, which returns a cached MP3 URL that plays
/// here. Replaces the on-device engine, whose robotic delivery undercut the
/// warmth the written feedback is meant to carry.
@lazySingleton
class TtsService {
  final AudioPlayer _player = AudioPlayer();

  /// Speaks [text] aloud. Completes once playback finishes, or immediately
  /// once [stop] is called from elsewhere.
  Future<void> speak(String text) async {
    final result = await FirebaseFunctions.instance
        .httpsCallable('synthesizeSpeech')
        .call<Map<String, dynamic>>({'text': text});

    await _player.setUrl(result.data['url'] as String);
    await _player.play();
    await _player.processingStateStream.firstWhere((s) => s == ProcessingState.completed);
    await _player.stop();
  }

  Future<void> stop() => _player.stop();
}