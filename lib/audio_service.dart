import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();

  static final ValueNotifier<bool> muted = ValueNotifier<bool>(false);

  static final AudioPlayer _correct = AudioPlayer();
  static final AudioPlayer _wrong = AudioPlayer();
  static final AudioPlayer _fireworks = AudioPlayer();

  static Future<void> init() async {
    try {
      // إعداد المشغلات لتكون جاهزة (وضع LowLatency يعمل بشكل ممتاز على الهاتف)
      await _correct.setPlayerMode(PlayerMode.lowLatency);
      await _wrong.setPlayerMode(PlayerMode.lowLatency);
      await _fireworks.setPlayerMode(PlayerMode.mediaPlayer);
      
      // هام جداً: يجب أن يطلق المشغل بعد انتهاء الصوت ليسمح بإعادة التشغيل
      await _correct.setReleaseMode(ReleaseMode.stop);
      await _wrong.setReleaseMode(ReleaseMode.stop);
      await _fireworks.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      debugPrint('AudioService init error: $e');
    }
  }

  static Future<void> playCorrect() async {
    if (muted.value) return;
    try {
      // نستخدم play مباشرة بدلاً من stop/resume لتجنب التأخير
      await _correct.play(AssetSource('audio/correct.wav'));
    } catch (e) {
      debugPrint('AudioService.playCorrect error: $e');
    }
  }

  static Future<void> playWrong() async {
    if (muted.value) return;
    try {
      await _wrong.play(AssetSource('audio/wrong.mp3'));
    } catch (e) {
      debugPrint('AudioService.playWrong error: $e');
    }
  }

  static Future<void> playFireworks() async {
    if (muted.value) return;
    try {
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