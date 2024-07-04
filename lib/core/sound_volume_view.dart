import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:process_run/process_run.dart';
import 'package:sound_volume_view/sound_volume_view_library.dart';

class SoundVolumeView {
  
  /// [shell] ProcessRun Shell
  late final Shell shell;

  /// [stateController] A StreamController that emits the state of the SoundVolumeView
  final stateController = StreamController<SoundVolumeViewState>.broadcast();
  
  /// [outputDevices] You only get the output devices
  List<Device> outputDevices = <Device>[];

  /// [applicationDevices] You only get the application devices
  List<Device> applicationDevices = <Device>[];

  /// [captureDevices] You only get the capture devices
  List<Device> captureDevices = <Device>[];

  /// [refreshDevices] refreshDevices gets all input, output, and application devices
  Future<List<Device>> refreshDevices() async => _refreshDevices();

  /// [_instance] The singleton instance of SoundVolumeView
  static final SoundVolumeView _instance = SoundVolumeView._();
  
  /// [SoundVolumeView] Creates a new instance of SoundVolumeView
  SoundVolumeView._() { shell = Shell(); }

  /// [getInstance] Get the singleton instance of SoundVolumeView
  static SoundVolumeView getInstance() => _instance;

  /// SoundVolumeView only working on Windows
  bool platformSupported() {
    if( !Platform.isWindows ) {
      stateController.add(SoundVolumeViewState.platformNotSupported);
      return false;
    }
    return true;
  }

  /// [checkIfSoundVolumeViewInstalled] checks if SoundVolumeView is installed in the system
  Future<bool> checkIfSoundVolumeViewInstalled() async {
    final isPlatformSupported = platformSupported();
    if( !isPlatformSupported ) return false;
    
    try {
      await shell.run('SoundVolumeView /GetPercent "CHECK"');
      stateController.add(SoundVolumeViewState.installed);
      return true;
    } catch( error ){
      stateController.add(SoundVolumeViewState.notInstalled);
      return false;
    }
  }

  /// [installSoundVolumeView] installs SoundVolumeView in the system
  Future<bool> installSoundVolumeView() async {
    final isPlatformSupported = platformSupported();
    if( !isPlatformSupported ) return false;

    try {
      await shell.run('winget install --id=NirSoft.SoundVolumeView -e');
      stateController.add(SoundVolumeViewState.installed);
    } catch( error ) {
      stateController.add(SoundVolumeViewState.errorToInstall);
    } 

    return true;
  }

  /// [uninstallSoundVolumeView] uninstalls SoundVolumeView in the system
  Future<bool> uninstallSoundVolumeView() async {
    final isPlatformSupported = platformSupported();
    if( !isPlatformSupported ) return false;

    String command = 'winget uninstall --id=NirSoft.SoundVolumeView -e';
    try {
      await shell.run(command);
      stateController.add(SoundVolumeViewState.uninstalled);
    } catch( error ) {
      stateController.add(SoundVolumeViewState.errorToUninstall);
    }
    return true;
  }

  /// Method private => [_refreshDevices] gets all input, ouput, and application devices operations.
  /// SaveFileEncoding 3 = UTF-8
  Future<List<Device>> _refreshDevices() async {
    captureDevices.clear();
    outputDevices.clear();
    applicationDevices.clear();
    
    final filePath = Platform.resolvedExecutable;
    final directoryExecutable = Directory(filePath).parent.path;
    final currentDirectory = Directory.current.path;
    final outputDevice = File(kDebugMode ? currentDirectory : directoryExecutable);
    final command = 'SoundVolumeView /SaveFileEncoding 3 /sjson ${outputDevice.path}/devices.json';

    try {
      await shell.run(command);
      final deviceFile = File('${outputDevice.path}/devices.json');

      if ( await deviceFile.exists()) {
        final dataString = await deviceFile.readAsString(encoding: utf8);
        final dataJson = jsonDecode(dataString);
        List<Device> devices = (dataJson as List).map((deviceJson) {
          Device device = Device.fromJson(deviceJson);
          if (device.direction == 'Capture' && device.type == 'Device' && device.deviceState == 'Active') {
            captureDevices.add(device);
          } else if (device.direction == 'Render' && device.type == 'Device' && device.deviceState == 'Active') {
            outputDevices.add(device);
          } else if (device.type == 'Application' && device.deviceState == 'Active') {
            applicationDevices.add(device);
          }

          return device;
        }).toList();
        return devices;
      } else {
        return [];
      }
    } catch( error ) {
      stateController.add(SoundVolumeViewState.errorToSaveFileEncoding);
      return [];
    }
  }

  /// [setVolume] Will lower or raise the volume to the indicated device - 0% to 100%
  Future<bool> setVolume(Device device, int volume) async {
    try {
      final command = 'SoundVolumeView /SetVolume ${device.name} $volume';
      await shell.run(command);
      return true;
    } catch( error ) {
      return false;
    }
  }

  /// [mute] mute the device
  Future<bool> mute(Device device) async {
    try {
      final command = 'SoundVolumeView /mute ${device.name}';
      device.muted = 'Yes';
      await shell.run(command);
      return true;
    } catch( error ) {
      return false;
    }
  }

  /// [unMute] Turn on device sound
  Future<bool> unMute(Device device) async {
    try {
      device.muted = 'No';
      final command = 'SoundVolumeView /UnMute ${device.name}';
      await shell.run(command);
      return true;
    } catch( error ) {
      return false;
    }
  }

  /// [setPlaybackThroughDevice] Assigns the output device to the recording line signal
  Future<bool> setPlaybackThroughDevice(Device recordingDevice, Device playbackDevice) async {
    final command = 'SoundVolumeView /SetPlaybackThroughDevice "${recordingDevice.name}" ${playbackDevice.itemID}';
    try {
      await shell.run(command);
      return true;
    } catch( error ) {
      return false;
    }
  }

  /// [setListenToThisDevice] Enable or disable recording line preview
  Future<bool> setListenToThisDevice(Device device,{bool listen = true}) async {
    try {
      final command = 'SoundVolumeView /SetListenToThisDevice ${device.name} ${listen ? 1 : 0}';
      await shell.run(command);
      return true;
    } catch( error ) {
      return false;
    }
  }

  /// [setAppDefault] Allows you to set the default render/capture device for specfic application.
  Future<bool> setAppDefault(Device applicationDevice, Device outputDevice, {DefaultType defaultType = DefaultType.multimedia}) async {
    switch (defaultType) {
      case DefaultType.console:        
        try {
          final command = 'SoundVolumeView /SetAppDefault "${outputDevice.commandLineFriendlyID}" 0 ${applicationDevice.processID}';
          await shell.run(command);
          return true;
        } catch( error ) {
          return false;
        }
      case DefaultType.multimedia:
        try {
          final command = 'SoundVolumeView /SetAppDefault "${outputDevice.commandLineFriendlyID}" 1 ${applicationDevice.processID}';
          await shell.run(command);
          return true;
        } catch( error ) {
          return false;
        }
      case DefaultType.communications:
        try {
          final command = 'SoundVolumeView /SetAppDefault "${outputDevice.commandLineFriendlyID}" 2 ${applicationDevice.processID}';
          await shell.run(command);
          return true;
        } catch( error ) {
          return false;
        }
      case DefaultType.all:
        try {
          final command = 'SoundVolumeView /SetAppDefault "${outputDevice.commandLineFriendlyID}" all ${applicationDevice.processID}';
          await shell.run(command);
          return true;
        } catch( error ) {
          return false;
        }
    }
  }

  /// [setDefault] Output devices set all default types (Console, Multimedia, and Communications)
  Future<bool> setDefault(Device outputDevice, {DefaultType defaultType = DefaultType.all}) async {
    switch (defaultType) {
      case DefaultType.console:
        try {
          final command = 'SoundVolumeView /SetDefault "${outputDevice.itemID}" 0';
          await shell.run(command);
          return true;
        } catch (error) { 
          return false;
        }
      case DefaultType.multimedia:
        try {
          final command = 'SoundVolumeView /SetDefault "${outputDevice.itemID}" 1';
          await shell.run(command);
          return true;
        } catch (error) { 
          return false;
        }
      case DefaultType.communications:
          try {
          final command = 'SoundVolumeView /SetDefault "${outputDevice.itemID}" 2';
          await shell.run(command);
          return true;
        } catch (error) { 
          return false;
        }
      case DefaultType.all:
        try {
          final command = 'SoundVolumeView /SetDefault "${outputDevice.itemID}" all';
          await shell.run(command);
          return true;
        } catch (error) { 
          return false;
        }
    }
  }
}
