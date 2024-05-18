import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sound_volume_view/core/sound_volume_view.dart';

void main() {
  test('Check if SoundVolumeView.exe exists', () async {
    try {
      final soundVolumeView = SoundVolumeView( isTesting: true );
      await soundVolumeView.refreshDevices();
    } on FileSystemException catch (e) {
      fail(e.message);
    }
  });
}
