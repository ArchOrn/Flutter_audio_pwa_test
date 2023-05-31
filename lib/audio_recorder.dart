import 'package:flutter/material.dart';
import 'package:record/record.dart';

class AudioRecorder extends StatefulWidget {
  const AudioRecorder({Key? key}) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  final Record _record = Record();

  bool _recording = false;
  int _duration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Duration: $_duration s'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _recording ? cancelRecording(context) : recordAudio(context);
                  },
                  child: Text(_recording ? 'Recording...' : 'Record'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> recordAudio(BuildContext context) async {
    try {
      if (await _record.hasPermission()) {
        // Start recording
        await _record.start(path: 'C:\\Users\\Raphael\\Desktop\\test.m4a');
        setState(() => _recording = true);
        _record.onAmplitudeChanged(const Duration(milliseconds: 500)).listen((Amplitude amplitude) {
          print('amplitude: ${amplitude.current}');
        });
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must grant permission to record to use this feature.'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelRecording(BuildContext context) async {
    try {
      if (await _record.hasPermission()) {
        // Stop recording
        final output = await _record.stop();
        print('output: $output');
        setState(() => _recording = false);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must grant permission to record to use this feature.'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
