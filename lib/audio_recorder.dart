import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class AudioRecorder {
  late FlutterSoundRecorder _audioRecorder;
  bool _isRecording = false;
  String? _filePath;

  AudioRecorder() {
    _audioRecorder = FlutterSoundRecorder();
  }

  Future<void> initializeRecorder(BuildContext context) async {
    await _audioRecorder.openRecorder();
    final permissionGranted = await _requestPermissions(context);
    if (!permissionGranted) {
      throw Exception("Permissions not granted");
    }
  }

  Future<bool> _requestPermissions(BuildContext context) async {
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = Platform.isAndroid
        ? await Permission.manageExternalStorage.request()
        : await Permission.storage.request();

    if (!microphoneStatus.isGranted || !storageStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions not granted')),
      );
      return false;
    }
    return true;
  }

  Future<void> startRecording() async {
    if (_isRecording) return; // Prevent starting multiple recordings

    final directory = await getApplicationDocumentsDirectory();

    // Get current date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    // Create file name with date and time
    _filePath = '${directory.path}/Dude_$formattedDate.aac';

    await _audioRecorder.startRecorder(toFile: _filePath);
    _isRecording = true;
  }

  Future<void> stopRecording(BuildContext context) async {
    if (!_isRecording) return; // Prevent stopping when not recording

    try {
      await _audioRecorder.stopRecorder();
      _isRecording = false;

      if (_filePath != null) {
        await _saveToGallery(_filePath!, context);
      }
    } catch (e) {
      print("Error stopping recorder: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
    }
  }

  Future<void> _saveToGallery(String filePath, BuildContext context) async {
    final directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final fileName = filePath.split('/').last;
    final newFilePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.copy(newFilePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Audio saved to $newFilePath')),
    );
  }

  bool get isRecording => _isRecording;

  Future<void> dispose() async {
    await _audioRecorder.closeRecorder();
  }
}
