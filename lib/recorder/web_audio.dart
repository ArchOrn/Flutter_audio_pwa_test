import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class WebAudio {
  final deviceInfoPlugin = DeviceInfoPlugin();

  final defaultMimeType = 'audio/webm;codecs=opus';
  final safariSpecificMimeType = 'audio/mp4';

  html.MediaStream? _stream;
  html.MediaRecorder? _recorder;
  String? _mimeType;
  List<html.Blob> _dataChunks = [];

  Future<void> startAudioRecording() async {
    final deviceInfo = await deviceInfoPlugin.webBrowserInfo;
    final browser = deviceInfo.browserName;
    _mimeType = browser == BrowserName.safari ? safariSpecificMimeType : defaultMimeType;

    _stream = await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    if (_stream != null) {
      _dataChunks = [];
      _recorder = html.MediaRecorder(_stream!, {
        'mimeType': _mimeType,
      });
      _recorder?.addEventListener('dataavailable', (event) {
        if (event is html.BlobEvent && event.data != null) {
          _dataChunks.add(event.data!);
        }
      });
      _recorder?.start();
    }
  }

  Future<Uint8List>? stopAudioRecording() async {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();
    if (_recorder != null) {
      _recorder?.requestData();
      _recorder?.addEventListener('stop', (event) {
        final blob = html.Blob(_dataChunks, _mimeType);
        print('final blob size: ${blob.size}');
        reader.onLoad.listen((event) {
          final uint8List = Uint8List.fromList(reader.result! as List<int>);
          completer.complete(uint8List);
        });
        reader.readAsArrayBuffer(blob);
      });
      _recorder?.stop();
      _recorder = null;
    }

    return completer.future;
  }

  html.Blob retrieveAudioBlob() {
    return html.Blob(_dataChunks, 'audio/webm');
  }

  String retrieveAudioBlobUrl() {
    final blob = html.Blob(_dataChunks, 'audio/webm');
    return html.Url.createObjectUrl(blob);
  }

  html.MediaStream retrieveAudioStream() {
    return _stream!;
  }
}
