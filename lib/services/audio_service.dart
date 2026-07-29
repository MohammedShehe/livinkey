import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;
  static String? _currentAsset;

  static Future<void> playBackgroundMusic(String assetPath) async {
    try {
      String cleanPath = assetPath;
      
      if (cleanPath.startsWith('assets/')) {
        cleanPath = cleanPath.replaceFirst('assets/', '');
      }
      
      if (!cleanPath.startsWith('audio/')) {
        if (!cleanPath.contains('/')) {
          cleanPath = 'audio/$cleanPath';
        }
      }
      
      if (_isPlaying && _currentAsset == cleanPath) {
        return;
      }

      if (_isPlaying) {
        await _player.stop();
        _isPlaying = false;
        _currentAsset = null;
      }
      
      try {
        await rootBundle.load('assets/$cleanPath');
      } catch (e) {
        return;
      }
      
      await _player.setSourceAsset(cleanPath);
      await _player.setReleaseMode(ReleaseMode.release);
      await _player.setVolume(0.5);
      await _player.resume();
      
      _isPlaying = true;
      _currentAsset = cleanPath;

      _player.onPlayerComplete.listen((event) {
        _isPlaying = false;
        _currentAsset = null;
      });
    } catch (e) {
      // Silent fail
    }
  }

  static Future<void> stopBackgroundMusic() async {
    try {
      if (_isPlaying) {
        await _player.stop();
        _isPlaying = false;
        _currentAsset = null;
      }
    } catch (e) {
      // Silent fail
    }
  }

  static void dispose() {
    try {
      _player.dispose();
      _isPlaying = false;
      _currentAsset = null;
    } catch (e) {
      // Silent fail
    }
  }
}