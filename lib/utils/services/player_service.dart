import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;

class PlayerService {
  PlayerService(this.audioPath, this.onStateChanged, this.onDurationChanged,
      this.onPositionChanged, this.onComplete);
  final String audioPath;
  final void Function(dynamic) onStateChanged;
  final void Function(Duration) onDurationChanged;
  final void Function(Duration) onPositionChanged;
  final void Function(dynamic) onComplete;

  final AudioPlayer _player = AudioPlayer();

  Future initANDupdate() async {
    await setAudio();
    _initializeListeners();
  }

  void dispose() {
    _player.dispose();
  }

  Future<void> setAudio() async {
    // https://github.com/bluefireteam/audioplayers/blob/main/getting_started.md#sources

    /// Repeat song when completed
    // audioPlayer.setReleaseMode(ReleaseMode.loop);

    /// check if a path is local path in OS filesystem JUST in syntax not really
    // final bool isAbsolutePath = !_imagePath!.contains('http://');
    // final bool isAbsolutePath = File(_imagePath!).isAbsolute; // import 'dart:io';
    final bool isAbsolutePath = p.isAbsolute(audioPath);

    if (isAbsolutePath) {
      await _player.setSourceDeviceFile(audioPath);
    } else {
      /// get the audio from a remote URL from the Internet. This can be a direct link to a supported file to be downloaded, or a radio stream.
      await _player.setSourceUrl(audioPath);
    }
  }

  void _initializeListeners() {
    // Listen to states: playing, paused, stopped, playing
    _player.onPlayerStateChanged.listen(onStateChanged);
    // Listen to audio duration
    _player.onDurationChanged.listen(onDurationChanged);
    // Listen to audio position
    _player.onPositionChanged.listen(onPositionChanged);
    // It does not fire when you interrupt the audio with pause or stop.
    _player.onPlayerComplete.listen(onComplete);
  }

  Future pause() async {
    await _player.pause();
  }

  Future resume() async {
    await _player.resume();
  }

  Future seek(Duration p) async {
    await _player.seek(p);
  }
}

/// I tried to play audio using the same plugin to record "flutter_sound" , BUT it was not work well in slider change(I don't know, Its my fault OR the plugin)

// import 'package:flutter_sound/flutter_sound.dart';

// class PlayerService {
//   PlayerService(this.audioPath, this.onComplete);
//   final String audioPath;
//   final void Function() onComplete;

//   late final FlutterSoundPlayer _player;

//   bool get isPlaying => _player.isPlaying;
//   Stream<PlaybackDisposition>? get onProgress => _player.onProgress;

//   Future initANDupdate() async {
//     _player = FlutterSoundPlayer();
//     await _player.openPlayer();
//     await setAudio();
//   }

//   Future<void> setAudio() async {
//     await _player.startPlayer(
//       fromURI: audioPath,
//       codec: Codec.aacADTS,
//       whenFinished: onComplete,
//     );

//     await _player.pausePlayer();
//     _player.setSubscriptionDuration(const Duration(
//         milliseconds: 500)); // to StreamBuilder update every 500 milliseconds
//   }

//   void dispose() {
//     _player.closePlayer();
//   }

//   Future _pause() async {
//     await _player.pausePlayer();
//   }

//   Future _resume() async {
//     await _player.resumePlayer();
//   }

//   Future _play() async {
//     await _player.startPlayer(
//         fromURI: audioPath, codec: Codec.aacADTS); // Play a temporary file
//   }

//   Future seek(Duration p) async {
//     await _player.seekToPlayer(p);
//   }

//   Future togglePlaying() async {
//     if (_player.isPlaying) {
//       await _pause();
//     } else if (_player.isPaused) {
//       await _resume();
//     } else {
//       await _play();
//     }
//   }
// }
