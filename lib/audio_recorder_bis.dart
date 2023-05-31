import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class AudioRecorderBis extends StatefulWidget {
  const AudioRecorderBis({Key? key}) : super(key: key);

  @override
  State<AudioRecorderBis> createState() => _AudioRecorderBisState();
}

class _AudioRecorderBisState extends State<AudioRecorderBis> {
  final _recorder = FlutterSoundRecorder();
  final _player = FlutterSoundPlayer();

  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                _recording ? cancelRecording(context) : recordAudio(context);
              },
              child: Text(_recording ? 'Recording...' : 'Record'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> recordAudio(BuildContext context) async {
    try {
      await _recorder.openRecorder();
      await _recorder.startRecorder(
        toFile: 'test_audio',
        codec: Codec.opusWebM,
        audioSource: AudioSource.microphone,
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e.'),
        ),
      );
    }
  }

  Future<void> cancelRecording(BuildContext context) async {
    try {
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e.'),
        ),
      );
    }
  }
}
