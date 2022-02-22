SoundVolumeView that displays general information and the current volume level for all active sound components in your system, and allows you to instantly mute and unmute them.

![](https://github.com/DomingoMG/sound_volume_view/blob/main/assets/SoundVolumeView.png?raw=true)

## Expressions of gratitude
First of all thanks to nirsoft for creating SoundVolumeView.exe. Without this it would not be possible for Windows.
https://www.nirsoft.net/utils/sound_volume_view.html

## Getting started
Supported platforms:  
  
  Windows [ ✅ ]
  
  MacOS [ ❌ ]
  
  Linux [ ❌ ]
  
  Android [ ❌ ]
  
  iOS [ ❌ ]

## Usage
SoftwarePath should indicate the folder where you have the executable ```SoundVolumeView.exe```..

```dart
SoundVolumeView soundVolumeView = SoundVolumeView(softwarePath: 'C:\\Program Files\\Sound\\');
```

#### First to get the devices you must call: ```soundVolumeView.getDevices;```
```dart
List<Device> devices = await soundVolumeView.getDevices;
```

### Once you have obtained the devices you will also have a separate list for each type.
```dart
  /// [captureDevices] You only get the capture devices
  soundVolumeView.captureDevices;

  /// [outputDevices] You only get the output devices
  soundVolumeView.outputDevices;

  /// [applicationDevices] You only get the application devices
  soundVolumeView.applicationDevices;
```

#### Set UnMute / Mute
```dart
await soundVolumeView.unMute( devices[index] );

await soundVolumeView.mute( devices[index] );
```

#### Set Volume: Range [0-100] int
```dart
await soundVolumeView.setVolume(soundVolumeView.captureDevices[index], 100);
```

#### You can also listen to the capture sound.
```dart
await soundVolumeView.setListenToThisDevice(devices[index], listen: true);
```

#### You can also set the sound output to the recording line or application devices
```dart
await soundVolumeView.setListenToThisDevice(devices[index], listen: true);
```

#### DefaultType: all - Set all default types (Console, Multimedia, and Communications)
```dart
enum DefaultType {
  console,
  multimedia,
  communications,
  all
}
```

#### You can assign output devices to applications via the pid process
```dart
Device outputDeviceFound = soundVolumeView.outputDevices.firstWhere((element) => element.itemID == itemId);
await soundVolumeView.setAppDefault(soundVolumeView.applicationDevices[index], device, defaultType: DefaultType.all);
```

#### You can assign output devices to applications via the pid process
```dart
await soundVolumeView.setDefault(soundVolumeView.outputDevices[index], defaultType: DefaultType.all);
```