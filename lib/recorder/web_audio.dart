import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class WebAudio {
  html.MediaStream? _stream;
  html.MediaRecorder? _recorder;
  List<html.Blob> _dataChunks = [];

  Future<void> startAudioRecording() async {
    _stream = await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    if (_stream != null) {
      _dataChunks = [];
      _recorder = html.MediaRecorder(_stream!, {
        'mimeType': 'audio/webm;codecs=opus',
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
        final blob = html.Blob(_dataChunks, 'audio/webm');
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
