import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderService {
  RecorderService(this.suggestFileName, this.onStopHandler);
  final String suggestFileName;
  final ValueChanged<String> onStopHandler;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  bool get isRecording => _recorder.isRecording;
  Stream<RecordingDisposition>? get onProgress => _recorder.onProgress;

  Future init() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await _recorder.openRecorder();
    _isRecorderInitialized = true;

    _recorder.setSubscriptionDuration(const Duration(
        milliseconds: 100)); // to StreamBuilder update every 500 milliseconds
  }

  void dispose() {
    if (!_isRecorderInitialized) return;

    _recorder.closeRecorder();
    _isRecorderInitialized = false;
  }

  Future _record() async {
    if (!_isRecorderInitialized) return;

    await _recorder.startRecorder(
        toFile: '$suggestFileName.aac', codec: Codec.aacADTS);
  }

  Future _stop() async {
    if (!_isRecorderInitialized) return;

    final path = await _recorder.stopRecorder();
    final audioFile = File(path!);
    onStopHandler(audioFile.path);

    /// TO SEE some extra info look at saveImagePermanently() notes in image_avatar_input.dart
    // print("recorded path: ${path}");
    // print("basename: ${p.basename(audioFile.path)}"); import 'package:path/path.dart' as p;
    // print("extension: ${p.extension(audioFile.path)}");
  }

  Future toggleRecording() async {
    if (_recorder.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
