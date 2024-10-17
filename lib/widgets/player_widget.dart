import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../utils/services/player_service.dart';
import '../utils/utils.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key, required this.audioPath});
  final String audioPath;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late PlayerService _player;
  late String _audioPath;
  bool isPlaying = false;
  Duration maxDuration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    runInInitAndUpdate;
    super.initState();
  }

  @override
  void didUpdateWidget(PlayerWidget oldWidget) {
    runInInitAndUpdate;
    // if (oldWidget.audioPath != widget.audioPath) {
    //   _runInInitAndUpdate;
    // }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _player.dispose();

    super.dispose();
  }

  void get runInInitAndUpdate {
    onStateChanged(s) {
      if (!mounted) return;
      setState(() => isPlaying = s == PlayerState.playing);
    }

    onDurationChanged(Duration d) {
      setState(() => maxDuration = d);
    }

    onPositionChanged(Duration p) {
      setState(() => position = p);
    }

    onComplete(event) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    }

    _audioPath = widget.audioPath;
    _player = PlayerService(_audioPath, onStateChanged, onDurationChanged,
        onPositionChanged, onComplete);
    _player.initANDupdate();
    // build new instance with new record audio, to get correct position and duration
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** player_widget build ***************');
    return maxDuration == Duration.zero // means if setAudio() not completed
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: LinearProgressIndicator(backgroundColor: Colors.grey),
          )
        : Column(
            children: [
              Row(
                children: [_buildPlayPause(), _buildSlider()],
              ),
              _buildProgress(),
            ],
          );
  }

  IconButton _buildPlayPause() {
    return IconButton(
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      onPressed: () async {
        if (isPlaying) {
          await _player.pause();
        } else {
          await _player
              .resume(); // Starts playback from current position (by default, from the start).
        }
      },
    );
  }

  Flexible _buildSlider() {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Slider(
        inactiveColor: Colors.grey,
        thumbColor: Colors.black,
        min: 0,
        max: maxDuration.inSeconds.toDouble(),
        value: position.inSeconds.toDouble(),
        onChanged: (value) async {
          final p = Duration(seconds: value.toInt());
          _player.seek(p);

          /// Optional: play audio if was paused before
          await _player.resume();
        },
      ),
    );
  }

  Padding _buildProgress() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Utils.formatTime(position)),
          Text(Utils.formatTime(maxDuration - position)),
        ],
      ),
    );
  }
}

/// I tried to play audio using the same plugin to record "flutter_sound" , BUT it was not work well in slider change(I don't know, Its my fault OR the plugin)

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// import '../utils/services/player_service.dart';
// import '../utils/utils.dart';
// import 'package:path/path.dart' as p;

// class PlayerWidget extends StatefulWidget {
//   const PlayerWidget({Key? key, required this.audioPath}) : super(key: key);
//   final String audioPath;

//   @override
//   State<PlayerWidget> createState() => _PlayerWidgetState();
// }

// class _PlayerWidgetState extends State<PlayerWidget> {
//   late PlayerService _player;
//   late String _audioPath;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     _audioPath = widget.audioPath;
//     runInInitAndUpdate;
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(PlayerWidget oldWidget) {
//     runInInitAndUpdate;
//     // if (oldWidget.audioPath != widget.audioPath) {
//     //   _runInInitAndUpdate;
//     // }

//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     _player.dispose();

//     super.dispose();
//   }

//   void get runInInitAndUpdate {
//     onComplete() {
//       if (!mounted) return;
//       setState(() {
//         position = Duration.zero;
//       });
//     }

//     _player = PlayerService(_audioPath, onComplete);
//     _player.initANDupdate();
//     initializeListeners;
//   }

//   void get initializeListeners {
//     _player.onProgress?.listen((onData) {
//       setState(() {
//         duration = onData.duration;
//         position = onData.position;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return duration == Duration.zero // means if setAudio() not completed
//         ? const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 32),
//             child: LinearProgressIndicator(backgroundColor: Colors.grey),
//           )
//         : Column(
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                         _player.isPlaying ? Icons.pause : Icons.play_arrow),
//                     onPressed: () async {
//                       await _player.togglePlaying();
//                       setState(() {});
//                     },
//                   ),
//                   Flexible(
//                     flex: 1,
//                     fit: FlexFit.tight,
//                     child: Slider(
//                       inactiveColor: Colors.grey,
//                       thumbColor: Colors.black,
//                       min: 0,
//                       max: duration.inSeconds.toDouble(),
//                       value: position.inSeconds.toDouble(),
//                       onChanged: (value) async {
//                         final p = Duration(seconds: value.toInt());
//                         _player.seek(p);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 60, right: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(Utils.formatTime(position)),
//                     Text(Utils.formatTime(duration - position)),
//                   ],
//                 ),
//               ),
//             ],
//           );
//   }
// }
