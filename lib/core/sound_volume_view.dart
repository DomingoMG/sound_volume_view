import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:process_run/process_run.dart';
import 'package:sound_volume_view/enums/default_type.dart';
import 'package:sound_volume_view/models/devices.dart';

class SoundVolumeView {
  
  late final Shell shell;
  late final File soundVolumeViewExecutable;

  SoundVolumeView({bool isTesting = false}) {
    shell = Shell();
    _checkPathForSoundVolumeViewExecutable(isTesting: isTesting);
  }

  /// [_checkPathForSoundVolumeViewExecutable] checks if SoundVolumeView.exe exists
  void _checkPathForSoundVolumeViewExecutable({bool isTesting = false}) {
    final filePath = Platform.resolvedExecutable;
    final directoryExecutable = Directory(filePath).parent.path;
    soundVolumeViewExecutable = File(isTesting
        ? 'vendors/SoundVolumeView.exe'
        : kDebugMode 
          ? '$directoryExecutable/vendors/SoundVolumeView.exe'
          : '$directoryExecutable/data/flutter_assets/vendors/SoundVolumeView.exe');
    if (!soundVolumeViewExecutable.existsSync()) {
      throw FileSystemException('$filePath not found',
          soundVolumeViewExecutable.path);
    }
  }

  /// [captureDevices] You only get the capture devices
  List<Device> captureDevices = <Device>[];

  /// [outputDevices] You only get the output devices
  List<Device> outputDevices = <Device>[];

  /// [applicationDevices] You only get the application devices
  List<Device> applicationDevices = <Device>[];

  /// [refreshDevices] refreshDevices gets all input, output, and application devices
  Future<List<Device>> refreshDevices() async => _refreshDevices();

  /// Method private => [_refreshDevices] gets all input, ouput, and application devices operations.
  // /SaveFileEncoding 3 = UTF-8
  Future<List<Device>> _refreshDevices() async {
    captureDevices.clear();
    outputDevices.clear();
    applicationDevices.clear();
    
    await shell.run('${soundVolumeViewExecutable.path} /SaveFileEncoding 3 /sjson ${soundVolumeViewExecutable.parent.path}/devices.json');
    final deviceFile = File('${soundVolumeViewExecutable.parent.path}/devices.json');

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
  }

  /// [setVolume] Will lower or raise the volume to the indicated device - 0% to 100%
  Future<void> setVolume(Device device, int volume) async {
    await shell.run('${soundVolumeViewExecutable.path} /SetVolume ${device.name} $volume');
  }

  /// [mute] mute the device
  Future<void> mute(Device device) async {
    device.muted = 'Yes';
    await shell.run('${soundVolumeViewExecutable.path} /mute ${device.name}');
  }

  /// [unMute] Turn on device sound
  Future<void> unMute(Device device) async {
    device.muted = 'No';
    await shell.run('${soundVolumeViewExecutable.path} /UnMute ${device.name}');
  }

  /// [setPlaybackThroughDevice] Assigns the output device to the recording line signal
  Future<void> setPlaybackThroughDevice(Device recordingDevice, Device playbackDevice) async {
    await shell.run('${soundVolumeViewExecutable.path} /SetPlaybackThroughDevice "${recordingDevice.name}" ${playbackDevice.itemID}');
  }

  /// [setListenToThisDevice] Enable or disable recording line preview
  Future<void> setListenToThisDevice(Device device,{bool listen = true}) async {
    await shell.run('${soundVolumeViewExecutable.path} /SetListenToThisDevice ${device.name} ${listen ? 1 : 0}');
  }

  /// [setAppDefault] Allows you to set the default render/capture device for specfic application.
  Future<void> setAppDefault(Device applicationDevice, Device outputDevice, {DefaultType defaultType = DefaultType.multimedia}) async {
    switch (defaultType) {
      case DefaultType.console:
        await shell.run(
            '${soundVolumeViewExecutable.path} /SetAppDefault "${outputDevice.commandLineFriendlyID}" 0 ${applicationDevice.processID}');
        break;
      case DefaultType.multimedia:
        await shell.run(
            '${soundVolumeViewExecutable.path} /SetAppDefault "${outputDevice.commandLineFriendlyID}" 1 ${applicationDevice.processID}');
        break;
      case DefaultType.communications:
        await shell.run(
            '${soundVolumeViewExecutable.path} /SetAppDefault "${outputDevice.commandLineFriendlyID}" 2 ${applicationDevice.processID}');
        break;
      case DefaultType.all:
        await shell.run(
            '${soundVolumeViewExecutable.path} /SetAppDefault "${outputDevice.commandLineFriendlyID}" all ${applicationDevice.processID}');
        break;
    }
  }

  /// [setDefault] Output devices set all default types (Console, Multimedia, and Communications)
  Future<void> setDefault(Device outputDevice,
      {DefaultType defaultType = DefaultType.all}) async {
    switch (defaultType) {
      case DefaultType.console:
        await shell.run('${soundVolumeViewExecutable.path} /SetDefault "${outputDevice.itemID}" 0');
        break;
      case DefaultType.multimedia:
        await shell.run('${soundVolumeViewExecutable.path} /SetDefault "${outputDevice.itemID}" 1');
        break;
      case DefaultType.communications:
        await shell.run('${soundVolumeViewExecutable.path} /SetDefault "${outputDevice.itemID}" 2');
        break;
      case DefaultType.all:
        await shell.run('${soundVolumeViewExecutable.path} /SetDefault "${outputDevice.itemID}" all');
        break;
    }
  }
}
