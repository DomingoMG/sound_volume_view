SoundVolumeView displays general information and the current volume level for all active sound components in your system and allows you to instantly mute and unmute them.

![](https://github.com/DomingoMG/sound_volume_view/blob/main/assets/SoundVolumeView.png?raw=true)

## Expressions of gratitude
First of all, thanks to NirSoft for creating SoundVolumeView.exe. Without this, it would not be possible for Windows.  
Visit [NirSoft SoundVolumeView](https://www.nirsoft.net/utils/sound_volume_view.html) for more information.

## Getting started
Supported platforms:
  - ✅ Windows
  - ❌ MacOS
  - ❌ Linux
  - ❌ Android
  - ❌ iOS
  - ❌ Web

## Usage
The `SoundVolumeView` instance will search for the executable via the command line. If it is not found, it will launch the SoundVolumeView installation internally.

#### Sigleton instance
```dart
SoundVolumeView soundVolumeView = SoundVolumeView.getInstance();
```

#### First make sure you have SoundVolumeView installed on your system. Example:
```dart
bool isCheckIfSoundVolumeViewInstalled = await soundVolumeView.checkIfSoundVolumeViewInstalled();

late bool isInstalled;
if( !isCheckIfSoundVolumeViewInstalled ) {
  isInstalled = await soundVolumeView.installSoundVolumeView();
}

if( isInstalled ) {
  await soundVolumeView.refreshDevices();
}
```

#### Second if you do not have SoundVolumeView installed, you can install it with the following command:
```dart
final isInstalled = await soundVolumeView.installSoundVolumeView();
if( !isInstalled ) ......
```

#### Third if you want to uninstall SoundVolumeView, you can run the following command:
```dart
final isUninstalled = await soundVolumeView.uninstallSoundVolumeView();
if( !isUninstalled ) ......
```

#### First to get the devices you must call: ```soundVolumeView.refreshDevices();```
```dart
List<Device> devices = await soundVolumeView.refreshDevices();
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
bool isUnMute = await soundVolumeView.unMute( devices[index] );

bool isMute = await soundVolumeView.mute( devices[index] );
```

#### Set Volume: Range [0-100] int
```dart
bool isSetVolume = await soundVolumeView.setVolume(soundVolumeView.captureDevices[index], 100);
```

#### You can also listen to the capture sound.
```dart
bool isSetListenToThisDevice = await soundVolumeView.setListenToThisDevice(devices[index], listen: true);
```

#### You can also set the sound output to the recording line
```dart
  Device outputDevice = soundVolumeView.outputDevices.firstWhere(( device ) => device.itemID == value);
  final isSetPlaybackThroughDevice = await soundVolumeView.setPlaybackThroughDevice(soundVolumeView.captureDevices[index], outputDevice);
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
final isSetAppDefault = await soundVolumeView.setAppDefault(soundVolumeView.applicationDevices[index], device, defaultType: DefaultType.all);
```

#### Indicates which is the default output device, communications, etc...
```dart
final isSetDefault = await soundVolumeView.setDefault(soundVolumeView.outputDevices[index], defaultType: DefaultType.all);
```