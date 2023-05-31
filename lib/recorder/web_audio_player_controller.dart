import 'package:flutter/material.dart';

class WebAudioPlayerController extends ValueNotifier<bool> {
  String? source;

  WebAudioPlayerController(super.value);

  void play(String url) {
    source = url;
    value = true;
  }
}
