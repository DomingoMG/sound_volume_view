## 2.0.0 
`checkIfSoundVolumeViewInstalled:` Añadida función para verificar si SoundVolumeView está instalado en el sistema.
`installSoundVolumeView:` Añadida función para instalar SoundVolumeView en el sistema.
`uninstallSoundVolumeView:` Añadida función para desinstalar SoundVolumeView del sistema.
`platformSupported:` Añadida función para verificar si la plataforma es compatible (actualmente solo Windows).
- Improvements:
  - Added a boolean return (`true` or `false`) to the following methods to indicate whether the operation was successful::
    - setVolume
    - mute
    - unMute
    - setPlaybackThroughDevice
    - setListenToThisDevice
    - setAppDefault
    - setDefault
- Added a StreamController to handle the state of `SoundVolumeViewState: [platformNotSupported, installed, notInstalled, errorToInstall, uninstalled, errorToUninstall, errorToSaveFileEncoding]`.

## 1.0.3
* BUG FIX: Missed adding assets before vendors

## 1.0.2
* BUG FIX: Searching for SoundVolumeView.exe caused a compilation error on Windows

## 1.0.1
* Now the file is searched in the Flutter build directory in debug mode and in release it is searched in the assets/vendors/SoundVolumeView.exe folder

## 1.0.0
* _checkPathForSoundVolumeViewExecutable() checks if SoundVolumeView.exe exists in the path of the program.

## 0.0.7
* UPDATE Readme.md
* softwarePath Now it's not mandatory, it's optional.
* Indicating the path or else it will look for it in the compilation files of the program.

## 0.0.6
* UPDATE Readme.md
* Added setAppDefault method
* Added setDefault method

## 0.0.4
* UPDATE Readme.md
* Added setListenToThisDevice method
* Added setPlaybackThroughDevice method

## 0.0.2
* Added device model
* Added unMute and mute methods.
* Added setListenToThisDevice method.

## 0.0.1
* TODO: Describe initial release.