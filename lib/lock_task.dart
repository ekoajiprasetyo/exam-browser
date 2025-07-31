import 'package:flutter/services.dart';

class LockTask {
  static const _channel = MethodChannel('exam_browser/locktask');

  static Future<void> start() async {
    try {
      await _channel.invokeMethod('startLockTask');
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopLockTask');
    } catch (_) {}
  }
}
