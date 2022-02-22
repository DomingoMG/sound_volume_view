

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:sound_volume_view/src/models/device.dart';

/// This file is a part of SoundVolumeView (https://github.com/DomingoMG/sound_volume_view.dart).
///
/// Copyright (c) 2022, Domingo Montesdeoca González <DomingoMG97@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
/// 

// DOCUMENTATION HERE: https://www.nirsoft.net/utils/sound_volume_view.html#command_line
class SoundVolumeView {

  SoundVolumeView({ required this.softwarePath });
  
  /// [softwarePath] Absolute path of where SoundVolumeView.exe is located
  String softwarePath;

  /// [_softwareName] Name of the application to run
  final String _softwareName = 'SoundVolumeView.exe';

  /// [captureDevices] You only get the capture devices
  List<Device> captureDevices = <Device>[];
  
  /// [outputDevices] You only get the output devices
  List<Device> outputDevices = <Device>[];
  
  /// [applicationDevices] 
  List<Device> applicationDevices = <Device>[];

  /// [getDevices] getDevices gets all input, output, and application devices
  Future<List<Device>> get getDevices async => _getDevices();

  
  /// Method private => [_getDevices] gets all input, ouput, and application devices operations.
  // /SaveFileEncoding 3 = UTF-8
  Future<List<Device>> _getDevices() async {
    String filenameToGenerate = 'devices.json';
    String path = join(softwarePath, _softwareName);
    String devicesPath = join(softwarePath, filenameToGenerate);
    File file = File(devicesPath);
    captureDevices.clear();
    outputDevices.clear();
    applicationDevices.clear();
    if( await file.exists() ) {
      await file.delete(); 
    }
    String pathSave = join(softwarePath, filenameToGenerate);
    final Shell shell = Shell();
    await shell.run('$path /SaveFileEncoding 3 /sjson $pathSave');
    
    if( await file.exists() ){
      final dataString = await file.readAsString(encoding:utf8);    
      final dataJson = jsonDecode(dataString);
      List<Device> devices = (dataJson as List).map(( deviceJson ) {
        Device device = Device.fromJson(deviceJson);
        if( device.direction == 'Capture' && device.type == 'Device' ){
          captureDevices.add(device);
        } else if( device.direction == 'Render' && device.type == 'Device' ){
          outputDevices.add(device);
        } else if( device.type == 'Application') {
          applicationDevices.add(device);
        }
        return device;
      }).toList();
      return devices;
    } else {
      return [];
    }
  }
  
  /// [mute] mute the device
  Future<void> mute ( Device device ) async {
    String path = join(softwarePath, _softwareName);
    final Shell shell = Shell();
    device.muted = 'Yes';
    await shell.run('$path /mute ${device.name}');
  }

  /// [unMute] Turn on device sound
  Future<void> unMute ( Device device ) async {
    String path = join(softwarePath, _softwareName);
    final Shell shell = Shell();
    device.muted = 'No';
    await shell.run('$path /UnMute ${device.name}');
  }

  /// [setPlaybackThroughDevice] Assigns the output device to the recording line signal
  Future<void> setPlaybackThroughDevice( Device recordingDevice, Device playbackDevice ) async {
    String path = join(softwarePath, _softwareName);
    final Shell shell = Shell();
    await shell.run('$path /SetPlaybackThroughDevice  ${recordingDevice.name} ${playbackDevice.itemID}');
  }

  /// [setListenToThisDevice] Enable or disable recording line preview
  Future<void> setListenToThisDevice ( Device device, {bool listen = true}) async {
    String path = join(softwarePath, _softwareName);
    final Shell shell = Shell();
    await shell.run('$path /SetListenToThisDevice ${device.name} ${listen ? 1 : 0}');
  }

}