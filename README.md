SoundVolumeView that displays general information and the current volume level for all active sound components in your system, and allows you to instantly mute and unmute them.

![](https://github.com/DomingoMG/sound_volume_view/blob/assets/SoundVolumeView.png?raw=true)

## Expressions of gratitude
First of all thanks to nirsoft for creating SoundVolumeView.exe. Without this it would not be possible for Windows.
https://www.nirsoft.net/utils/sound_volume_view.html

## Getting started
Supported platforms:  
  
  Windows [ X ]
  
  MacOS [ ]
  
  Linux [ ]
  
  Android [ ]
  
  iOS [ ]

## Usage
SoftwarePatch should indicate the folder where you have the executable ```SoundVolumeView.exe```..

```dart
SoundVolumeView soundVolumeView = SoundVolumeView(softwarePath: 'C:\\Program Files\\Sound\\');
```

#### Get list of input and output devices
```dart
List<Device> devices = await soundVolumeView.getDevices;
```

#### Set UnMute / Mute
```dart
await soundVolumeView.unMute( devices[index] );

await soundVolumeView.mute( devices[index] );
```

#### You can also listen to the capture sound.
```dart
await soundVolumeView.setListenToThisDevice(devices[index], listen: true);
```