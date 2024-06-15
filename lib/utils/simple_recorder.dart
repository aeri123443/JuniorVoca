import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:audio_session/audio_session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

typedef Fn = void Function();
typedef TranscriptionCallback = void Function(String transcription); // 콜백 타입 정의
const theSource = AudioSource.microphone;
var logger = Logger();

class SimpleRecorder {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'temp_file.mp4';
  FlutterSoundPlayer? _mPlayer;
  FlutterSoundRecorder? _mRecorder;
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  TranscriptionCallback? _transcriptionCallback; // 콜백 변수

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
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
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

  Future<void> _uploadAudio() async {
    try {
      // IP 주소를 가져온 후 POST 요청 생성
      final ipAddress = dotenv.env['IP_ADDRESS'];
      final uri = Uri.parse('http://$ipAddress:5001/upload');
      final request = http.MultipartRequest('POST', uri);

      // 임시 디렉토리 생성 후 파일을 멀티파트 요청에 추가
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$_mPath';
      final file = File(filePath);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // 요청 및 응답을 문자열로 변환
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      // 서버 응답 확인
      if (response.statusCode == 200) {
        logger.i('File uploaded successfully.');

        // 응답을 JSON으로 변환
        final jsonResponse = jsonDecode(responseBody);
        final transcription = jsonResponse['transcription'];

        // 콜백이 있을 경우 호출
        if (_transcriptionCallback != null) {
          _transcriptionCallback!(transcription); 
        }
      } else {
        logger.e('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error uploading file: $e');
    }
  }

  void setTranscriptionCallback(TranscriptionCallback callback) {
    _transcriptionCallback = callback;
  }
}
