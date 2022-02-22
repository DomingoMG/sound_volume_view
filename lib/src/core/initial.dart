

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
class SoundVolumeView {

  SoundVolumeView({ required this.softwarePath });
  
  String? softwarePath;
  final String _softwareName = 'SoundVolumeView.exe';
  Future<List<Device>> get getDevices async => _getDevices();


  // DOCUMENTATION HERE: https://www.nirsoft.net/utils/sound_volume_view.html#command_line
  // /SaveFileEncoding 3 = UTF-8
  Future<List<Device>> _getDevices() async {
    String filenameToGenerate = 'devices.json';
    String path = join(softwarePath!, _softwareName);
    String devicesPath = join(softwarePath!, filenameToGenerate);
    File file = File(devicesPath);
    if( await file.exists() ) {
      await file.delete(); 
    }
    String pathSave = join(softwarePath!, filenameToGenerate);
    final Shell shell = Shell();
    await shell.run('$path /SaveFileEncoding 3 /sjson $pathSave');
    
    if( await file.exists() ){
      final dataString = await file.readAsString(encoding:utf8);    
      final dataJson = jsonDecode(dataString);
      return (dataJson as List).map(( deviceJson ) => Device.fromJson(deviceJson)).toList();
    } else {
      return [];
    }
  }
  
  /// [GetMute] 
  /// Returns the current Mute status. (1 = Muted, 0 = Not Muted)
  Future<int> _getMute () async {
    return await Future.delayed(Duration.zero);
  }

  Future<void> mute ( Device device ) async {
    String path = join(softwarePath!, _softwareName);
    final Shell shell = Shell();
    device.muted = 'Yes';
    await shell.run('$path /mute ${device.name}');
  }

  Future<void> unMute ( Device device ) async {
    String path = join(softwarePath!, _softwareName);
    final Shell shell = Shell();
    device.muted = 'No';
    await shell.run('$path /UnMute ${device.name}');
  }

  Future<void> setListenToThisDevice ( Device device, {bool listen = true} ) async {
    String path = join(softwarePath!, _softwareName);
    final Shell shell = Shell();
    await shell.run('$path /SetListenToThisDevice ${device.name} ${listen ? 1 : 0}');
  }

}