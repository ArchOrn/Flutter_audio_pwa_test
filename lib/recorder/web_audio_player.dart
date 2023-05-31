import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:audio_pwa/recorder/web_audio_player_controller.dart';
import 'package:flutter/material.dart';

class WebAudioPlayer extends StatelessWidget {
  final viewId = 'web_audio_player';
  final WebAudioPlayerController? controller;

  html.AudioElement? _element;

  WebAudioPlayer({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _element = html.AudioElement();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) => _element!);

    return SizedBox(
      width: 100,
      height: 100,
      child: HtmlElementView(viewType: viewId),
    );
  }

  void play(String url) {
    _element?.src = url;
    _element?.play();
  }

  void playStream(html.MediaStream stream) {
    _element?.srcObject = stream;
    _element?.play();
  }

  void pause() {
    _element?.pause();
  }
}
