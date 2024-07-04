
class SoundVolumeViewException implements Exception {
  final String message;

  SoundVolumeViewException(this.message);

  @override
  String toString() => 'SoundVolumeViewException: $message';
}