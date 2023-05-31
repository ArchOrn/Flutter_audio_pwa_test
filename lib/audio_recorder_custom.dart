import 'package:audio_pwa/recorder/web_audio.dart';
import 'package:audio_pwa/recorder/web_audio_player.dart';
import 'package:flutter/material.dart';

class AudioRecorderCustom extends StatefulWidget {
  const AudioRecorderCustom({Key? key}) : super(key: key);

  @override
  State<AudioRecorderCustom> createState() => _AudioRecorderCustomState();
}

class _AudioRecorderCustomState extends State<AudioRecorderCustom> {
  final _webAudio = WebAudio();
  final _webAudioPlayerKey = GlobalKey();

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
                    _recording ? stopRecording(context) : startRecording(context);
                  },
                  child: Text(_recording ? 'Recording...' : 'Record'),
                ),
                const SizedBox(height: 20),
                WebAudioPlayer(key: _webAudioPlayerKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> startRecording(BuildContext context) async {
    try {
      await _webAudio.startAudioRecording();
      setState(() => _recording = true);
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopRecording(BuildContext context) async {
    try {
      final data = await _webAudio.stopAudioRecording();
      print('data: $data');
      final blobUrl = _webAudio.retrieveAudioBlobUrl();
      print('blobUrl: $blobUrl');
      (_webAudioPlayerKey.currentWidget as WebAudioPlayer?)?.play(blobUrl);
      setState(() => _recording = false);
    } catch (e) {
      print(e);
    }
  }
}
