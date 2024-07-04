import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sound_volume_view/core/sound_volume_view.dart';

void main() {
  SoundVolumeView soundVolumeView = SoundVolumeView.getInstance();

  setUp(() {
    soundVolumeView.stateController.stream.listen((state) => debugPrint(state.toString()));
  });

  test('Check SoundVolumeView in terminal', () async {
    final isInstalled = await soundVolumeView.checkIfSoundVolumeViewInstalled();
    debugPrint('SoundVolumeView is installed: $isInstalled');
  });

  test('Install SoundVolumeView in terminal', () async {
    final isInstalled = await soundVolumeView.installSoundVolumeView();
    debugPrint('SoundVolumeView already installed: $isInstalled');
  });

  test('Uninstall SoundVolumeView in terminal', () async {
    final isUninstalled = await soundVolumeView.uninstallSoundVolumeView();
    debugPrint('SoundVolumeView uninstalled: $isUninstalled');
  });

  test('Get devices list', () async {
    final devices = await soundVolumeView.refreshDevices();
    
    // Alls devices: Capture, Output, Application, etc...
    debugPrint('SoundVolumeView devices: ${devices.length}');

    final captureDevices = soundVolumeView.captureDevices;
    final outputDevices = soundVolumeView.outputDevices;
    final applicationDevices = soundVolumeView.applicationDevices;
    
    // Capture devices: Microphone, Line, Auriculares, etc...
    debugPrint('SoundVolumeView captureDevices: ${captureDevices.length}');

    // Output devices: Headphones, Speakers, etc...
    debugPrint('SoundVolumeView outputDevices: ${outputDevices.length}');

    // WhatsApp, YouTube, Spotify, Another application....
    debugPrint('SoundVolumeView applicationDevices: ${applicationDevices.length}');
  });

  test('Set volume', () async { 
    final isSetVolume = await soundVolumeView.setVolume(soundVolumeView.outputDevices[0], 50);
    debugPrint('SoundVolumeView set volume: $isSetVolume');
  });


  test('Set Mute', () async { 
    final isSetMute = await soundVolumeView.mute(soundVolumeView.outputDevices[0]);
    debugPrint('SoundVolumeView set mute: $isSetMute');
  });

  test('Set UnMute', () async { 
    final isSetUnMute = await soundVolumeView.unMute(soundVolumeView.outputDevices[0]);
    debugPrint('SoundVolumeView set unMute: $isSetUnMute');
  });

  test('Set Playback Through Device', () async { 
    final isSetPlaybackThroughDevice = await soundVolumeView.setPlaybackThroughDevice(soundVolumeView.captureDevices[0], soundVolumeView.outputDevices[0]);
    debugPrint('SoundVolumeView set playback through device: $isSetPlaybackThroughDevice');
  });

  test('Set Listen To This Device', () async { 
    final isSetListenToThisDevice = await soundVolumeView.setListenToThisDevice(soundVolumeView.outputDevices[0], listen: true);
    debugPrint('SoundVolumeView set listen to this device: $isSetListenToThisDevice');
  });

  test('Set App Default', () async { 
    final isSetAppDefault = await soundVolumeView.setAppDefault(soundVolumeView.applicationDevices[0], soundVolumeView.outputDevices[0]);
    debugPrint('SoundVolumeView set app default: $isSetAppDefault');
  });

  test('Set Default', () async { 
    final isSetDefault = await soundVolumeView.setDefault(soundVolumeView.outputDevices[0]);
    debugPrint('SoundVolumeView set default: $isSetDefault');
  });
}
