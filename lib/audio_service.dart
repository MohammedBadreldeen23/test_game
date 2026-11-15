import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();

  // نخزن حالة الكتم في ValueNotifier حتى تُحدِّث الواجهة تلقائيًا
  static final ValueNotifier<bool> muted = ValueNotifier<bool>(false);

  static final AudioPlayer _correct = AudioPlayer();
  static final AudioPlayer _wrong = AudioPlayer();
  static final AudioPlayer _fireworks = AudioPlayer();

  /// نغمة إجابة صحيحة
  static Future<void> playCorrect() async {
    if (muted.value) return;
    try {
      await _correct.stop();
      await _correct.play(AssetSource('audio/correct.wav'));
    } catch (e) {
      debugPrint('AudioService.playCorrect error: $e');
    }
  }

  /// نغمة إجابة خاطئة
  static Future<void> playWrong() async {
    if (muted.value) return;
    try {
      await _wrong.stop();
      await _wrong.play(AssetSource('audio/wrong.mp3'));
    } catch (e) {
      debugPrint('AudioService.playWrong error: $e');
    }
  }

  /// ألعاب نارية احتفالية عند إتمام الاختبار
  static Future<void> playFireworks() async {
    if (muted.value) return;
    try {
      await _fireworks.stop();
      await _fireworks.play(AssetSource('audio/fireworks.mp3'));
    } catch (e) {
      debugPrint('AudioService.playFireworks error: $e');
    }
  }

  static Future<void> dispose() async {
    await _correct.dispose();
    await _wrong.dispose();
    await _fireworks.dispose();
  }
}