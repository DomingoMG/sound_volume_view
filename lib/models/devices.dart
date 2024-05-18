
class Device {
  String? name;
  String? type;
  String? direction;
  String? deviceName;
  String? defaultStr;
  String? defaultMultimedia;
  String? defaultCommunications;
  String? deviceState;
  String? muted;
  String? volumeDB;
  String? volumePercent;
  String? minVolumeDB;
  String? maxVolumeDB;
  String? volumeStep;
  String? channelsCount;
  String? channelsDB;
  String? channelsPercent;
  String? itemID;
  String? commandLineFriendlyID;
  String? processPath;
  String? processID;
  String? windowTitle;
  String? registryKey;
  bool listen = true;

  Device(
      {this.name,
      this.type,
      this.direction,
      this.deviceName,
      this.defaultStr,
      this.defaultMultimedia,
      this.defaultCommunications,
      this.deviceState,
      this.muted,
      this.volumeDB,
      this.volumePercent,
      this.minVolumeDB,
      this.maxVolumeDB,
      this.volumeStep,
      this.channelsCount,
      this.channelsDB,
      this.channelsPercent,
      this.itemID,
      this.commandLineFriendlyID,
      this.processPath,
      this.processID,
      this.windowTitle,
      this.registryKey});

  Device.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    type = json['Type'];
    direction = json['Direction'];
    deviceName = json['Device Name'];
    defaultStr = json['Default'];
    defaultMultimedia = json['Default Multimedia'];
    defaultCommunications = json['Default Communications'];
    deviceState = json['Device State'];
    muted = json['Muted'];
    volumeDB = json['Volume dB'];
    volumePercent = json['Volume Percent'];
    minVolumeDB = json['Min Volume dB'];
    maxVolumeDB = json['Max Volume dB'];
    volumeStep = json['Volume Step'];
    channelsCount = json['Channels Count'];
    channelsDB = json['Channels dB'];
    channelsPercent = json['Channels  Percent'];
    itemID = json['Item ID'];
    commandLineFriendlyID = json['Command-Line Friendly ID'];
    processPath = json['Process Path'];
    processID = json['Process ID'];
    windowTitle = json['Window Title'];
    registryKey = json['Registry Key'];
    listen = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Type'] = type;
    data['Direction'] = direction;
    data['Device Name'] = deviceName;
    data['Default'] = defaultStr;
    data['Default Multimedia'] = defaultMultimedia;
    data['Default Communications'] = defaultCommunications;
    data['Device State'] = deviceState;
    data['Muted'] = muted;
    data['Volume dB'] = volumeDB;
    data['Volume Percent'] = volumePercent;
    data['Min Volume dB'] = minVolumeDB;
    data['Max Volume dB'] = maxVolumeDB;
    data['Volume Step'] = volumeStep;
    data['Channels Count'] = channelsCount;
    data['Channels dB'] = channelsDB;
    data['Channels  Percent'] = channelsPercent;
    data['Item ID'] = itemID;
    data['Command-Line Friendly ID'] = commandLineFriendlyID;
    data['Process Path'] = processPath;
    data['Process ID'] = processID;
    data['Window Title'] = windowTitle;
    data['Registry Key'] = registryKey;
    return data;
  }
}