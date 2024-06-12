import 'dart:async';
import 'dart:io';
import 'dart:convert'; // 추가된 부분
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; // 임시 디렉토리 접근을 위해 추가
import 'package:http/http.dart' as http;

String ipAddress = '000.000.000.000'; // IP 정보 입력 필요
typedef Fn = void Function();
const theSource = AudioSource.microphone;

class SimpleRecorder {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'temp_file.mp4';
  FlutterSoundPlayer? _mPlayer;
  FlutterSoundRecorder? _mRecorder;
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  Future<void> init() async {
    _mPlayer = FlutterSoundPlayer();
    _mRecorder = FlutterSoundRecorder();

    await _mPlayer!.openPlayer();
    _mPlayerIsInited = true;

    await openTheRecorder();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      // 마이크 권한 요청
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'temp_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    // 오디오 세션 구성
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // 녹음 시작
  void startRecorder() {
    _mRecorder!.startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    );
  }

  // 녹음 중지
  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      _mplaybackReady = true;
      _uploadAudio();
    });
  }

  // 재생 시작
  void startPlayer() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!.startPlayer(
      fromURI: _mPath
    );
  }

  // 재생 중지
  void stopPlayer() {
    _mPlayer!.stopPlayer();
  }

  // 녹음 함수 반환
  Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? startRecorder : stopRecorder;
  }

  // 재생 함수 반환
  Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? startPlayer : stopPlayer;
  }

  // 리소스 해제
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
  }

  // 오디오 파일 업로드
  Future<void> _uploadAudio() async {
    print("Running: _uploadAudio()");
    try {
      final uri = Uri.parse('http://$ipAddress:5001/upload');
      final request = http.MultipartRequest('POST', uri);

      // 임시 디렉토리에서 파일 경로 가져오기
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$_mPath';
      print("filePath: ${filePath}");
      final file = File(filePath);
      print("file: ${file}");
      
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString(); // 응답 본문 추출
      print("Response status: ${response.statusCode}");
      print("Response body: $responseBody['transcription']");
      if (response.statusCode == 200) {
        print('File uploaded successfully.');
        final jsonResponse = jsonDecode(responseBody);
        final transcription = jsonResponse['transcription'];
        print('Transcription: $transcription');
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
