
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:sound_volume_view/sound_volume_view.dart';

late String softwarePath = 'D:\\Trabajos\\sound_volume_view\\';
const String softwareName = 'SoundVolumeView.exe';

Future<void> main() async {
  await checkSoftware();
  List<Device> devices = await getDevices();
  for ( Device device in devices ){
    print(device.toJson());
  }
  
}

// CHECK SOFTWARE EXIST
Future<void> checkSoftware() async {
  if( Platform.isWindows ){
    File file = File(join(softwarePath, softwareName));
    bool isFound = await file.exists();  
    if( isFound ) {
      return;
    } else {
      throw Exception('Please, Select the executable of SoundVolumeView.exe');
    }
  }
}

// DOCUMENTATION HERE: https://www.nirsoft.net/utils/sound_volume_view.html#command_line
// /SaveFileEncoding 3 = UTF-8
Future<List<Device>> getDevices() async {
  final Shell shell = Shell();
  String filenameToGenerate = 'devices.json';
  String path = join(softwarePath, softwareName);
  await shell.run('$path /SaveFileEncoding 3 /sjson $filenameToGenerate');
  
  String devicesPath = join(softwarePath, filenameToGenerate);
  File file = File(devicesPath);
  if( await file.exists() ){
    final dataString = await file.readAsString(encoding:utf8);    
    final dataJson = jsonDecode(dataString);
    return (dataJson as List).map(( deviceJson ) => Device.fromJson(deviceJson)).toList();
  } else {
    return [];
  }
}