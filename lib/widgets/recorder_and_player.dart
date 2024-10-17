import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'player_widget.dart';
import 'recorder_widget.dart';

class RecorderAndPlayer extends StatefulWidget {
  const RecorderAndPlayer({
    super.key,
    required this.onStopHandler,
    required this.suggestFleName,
    this.initialAudioPath,
    this.isLoading = false,
  });

  final String? initialAudioPath;
  final String suggestFleName;
  final ValueChanged<String> onStopHandler;
  final bool isLoading;

  @override
  State<RecorderAndPlayer> createState() => _RecorderAndPlayerState();
}

class _RecorderAndPlayerState extends State<RecorderAndPlayer> {
  String? _audioPath;
  @override
  void initState() {
    _audioPath = widget.initialAudioPath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** recorder_and_player build ***************');
    return widget.isLoading
        ? const Center(child: kCircularProgressIndicator)
        : Column(
            children: [
              if (_audioPath != null) PlayerWidget(audioPath: _audioPath!),
              RecorderWidget(
                suggestFileName: widget.suggestFleName,
                onStopHandler: (String audioPath) {
                  setState(() => _audioPath = audioPath);
                  widget.onStopHandler(audioPath);
                },
              ),
            ],
          );
  }
}
