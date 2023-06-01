import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Player extends StatefulWidget {
  final String url;

  const Player({Key? key, required this.url}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }


  @override
  void didUpdateWidget(Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _player.playing ? _player.pause() : _player.play();
            },
            child: Icon(_player.playing ? Icons.pause : Icons.play_arrow),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 5,
              child: LinearProgressIndicator(
                value: _player.duration != null && _player.duration!.inSeconds > 0
                    ? _player.position.inSeconds / _player.duration!.inSeconds
                    : 0,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_player.position)),
              Text(_formatDuration(_player.duration ?? Duration.zero)),
            ],
          ),
        ],
      ),
    );
  }

  void _loadAudio() {
    _player.setAudioSource(AudioSource.uri(Uri.parse(widget.url)));
    _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
      setState(() {});
    });
    _player.positionStream.listen((event) {
      setState(() {});
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
