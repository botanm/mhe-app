import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import '../utils/services/recorder_service.dart';
import '../utils/utils.dart';

class RecorderWidget extends StatefulWidget {
  const RecorderWidget(
      {super.key, required this.suggestFileName, required this.onStopHandler});

  final ValueChanged<String> onStopHandler;
  final String suggestFileName;

  @override
  State<RecorderWidget> createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  late final RecorderService _recorder;

  @override
  void initState() {
    super.initState();

    _recorder = RecorderService(widget.suggestFileName, widget.onStopHandler);
    _recorder.init();
  }

  @override
  void dispose() {
    _recorder.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('*************** recorder_widget build ***************');
    final isRecording = _recorder.isRecording;
    return Column(
      children: [
        const SizedBox(height: 32),
        if (isRecording) _buildTimer(),
        const SizedBox(height: 12),
        _buildStartStop(isRecording)
      ],
    );
  }

  StreamBuilder<RecordingDisposition> _buildTimer() {
    return StreamBuilder<RecordingDisposition>(
      stream: _recorder.onProgress,
      builder: (context, snapshot) {
        final duration =
            snapshot.hasData ? snapshot.data!.duration : Duration.zero;

        return Text(
          Utils.formatTime(duration),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  ElevatedButton _buildStartStop(bool isRecording) {
    final icon = isRecording ? Icons.stop : Icons.mic;
    final backgroundColor = isRecording ? Colors.black : Colors.black;
    final foregroundColor = isRecording ? Colors.red : Colors.red;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: backgroundColor, // <-- Button color
        foregroundColor: foregroundColor, // <-- Splash color
      ),
      onPressed: () async {
        await _recorder.toggleRecording();
        setState(() {});
      },
      child: Icon(icon, color: Colors.white, size: 35.0),
    );
  }
}
