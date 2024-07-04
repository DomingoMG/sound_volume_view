import 'package:flutter/material.dart';
import 'package:sound_volume_view/sound_volume_view_library.dart';
/// This file is a part of SoundVolumeView (https://github.com/DomingoMG/sound_volume_view.dart).
///
/// Copyright (c) 2024, Domingo Montesdeoca González <DomingoMG97@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
///
void main() => runApp(const SoundVolumeViewApp());

class SoundVolumeViewApp extends StatelessWidget {
  const SoundVolumeViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sound Volume View', home: HomePage());
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SoundVolumeView soundVolumeView = SoundVolumeView.getInstance();

  @override
  void initState() {    
    soundVolumeView.stateController.stream.listen((state) => _onSoundVolumeViewState(state));
    
    Future.microtask(() async {
      final checkSoundVolumeViewInstalled = await soundVolumeView.checkIfSoundVolumeViewInstalled();
      if( !checkSoundVolumeViewInstalled ) {
        bool isInstalled = await soundVolumeView.installSoundVolumeView();
        if( !isInstalled ) return throw Exception('SoundVolumeView not installed');
        debugPrint('SoundVolumeView Already installed');
        await soundVolumeView.refreshDevices();
        if( !mounted ) return;
        setState(() {});
      }

      if( checkSoundVolumeViewInstalled ){
        await soundVolumeView.refreshDevices();
        if( !mounted ) return;
        setState(() {});
      }
      
    });
    super.initState();
  }

  void _onSoundVolumeViewState( SoundVolumeViewState state ) {
    debugPrint('SoundVolumeView state: $state');
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController1 = ScrollController();
    final ScrollController scrollController2 = ScrollController();
    final ScrollController scrollController3 = ScrollController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sound Volume View'),
          actions: [
            IconButton(
              icon: const Icon(Icons.remove_moderator_outlined),
              tooltip: 'Uninstall SoundVolumeView',
              onPressed: () async {
                final isUninstalled = await soundVolumeView.uninstallSoundVolumeView();
                debugPrint('SoundVolumeView uninstalled: $isUninstalled');
              },
            ),
            const SizedBox(width: 90),
          ],
        ),
        body: Column(
          children: [
            ListTile(
                title: const Text(
                    'Example of sound volume view with basic functionalities',
                    style: TextStyle(fontSize: 25)),
                subtitle: const Text('DomingoMG'),
                trailing: IconButton(
                  icon: const Icon(Icons.sync),
                  tooltip: 'Refresh',
                  onPressed: () async {
                    await soundVolumeView.refreshDevices();
                    setState(() {});
                  },
                )),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.red.shade100,
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text('Capture Devices'),
                            subtitle:
                                Text('Input devices connected to your system'),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController1,
                              itemCount: soundVolumeView.captureDevices.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) =>
                                  Card(
                                      child: ListTile(
                                title: Text(soundVolumeView
                                    .captureDevices[index].name!),
                                subtitle: Text(soundVolumeView
                                    .captureDevices[index].deviceName!),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      tooltip: soundVolumeView
                                                  .captureDevices[index]
                                                  .muted ==
                                              'No'
                                          ? 'Muted'
                                          : 'unMute',
                                      icon: soundVolumeView
                                                  .captureDevices[index]
                                                  .muted ==
                                              'Yes'
                                          ? const Icon(Icons.volume_off,
                                              color: Colors.red)
                                          : const Icon(Icons.volume_up,
                                              color: Colors.green),
                                      onPressed: () async {
                                        soundVolumeView.setVolume(
                                            soundVolumeView
                                                .captureDevices[index],
                                            100);
                                        if (soundVolumeView
                                                .captureDevices[index].muted ==
                                            'Yes') {
                                          await soundVolumeView.unMute(
                                              soundVolumeView
                                                  .captureDevices[index]);
                                        } else {
                                          await soundVolumeView.mute(
                                              soundVolumeView
                                                  .captureDevices[index]);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.record_voice_over,
                                          color: Colors.black),
                                      tooltip: 'Listen',
                                      onPressed: () async {
                                        if (soundVolumeView
                                            .captureDevices[index].listen) {
                                          soundVolumeView.captureDevices[index]
                                              .listen = false;
                                        } else {
                                          soundVolumeView.captureDevices[index]
                                              .listen = true;
                                        }
                                        await soundVolumeView
                                            .setListenToThisDevice(
                                                soundVolumeView
                                                    .captureDevices[index],
                                                listen: soundVolumeView
                                                    .captureDevices[index]
                                                    .listen);
                                      },
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height: 90,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        items: soundVolumeView.outputDevices
                                            .map((output) => DropdownMenuItem(
                                                  value: output.itemID,
                                                  child: Text(output.name!),
                                                ))
                                            .toList(),
                                        onChanged: (String? value) async {
                                          final device = soundVolumeView
                                              .outputDevices
                                              .firstWhere((element) =>
                                                  element.itemID == value);
                                          await soundVolumeView
                                              .setPlaybackThroughDevice(
                                                  soundVolumeView
                                                      .captureDevices[index],
                                                  device);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.blue.shade100,
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text('Application Devices'),
                            subtitle: Text('Output devices via app'),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController2,
                              itemCount:
                                  soundVolumeView.applicationDevices.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) =>
                                  Card(
                                      child: ListTile(
                                title: Text(soundVolumeView
                                    .applicationDevices[index].name!),
                                subtitle: Text(soundVolumeView
                                    .applicationDevices[index].deviceName!),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      icon: soundVolumeView
                                                  .applicationDevices[index]
                                                  .muted ==
                                              'Yes'
                                          ? const Icon(Icons.volume_off,
                                              color: Colors.red)
                                          : const Icon(Icons.volume_up,
                                              color: Colors.green),
                                      onPressed: () async {
                                        if (soundVolumeView
                                                .applicationDevices[index]
                                                .muted ==
                                            'Yes') {
                                          await soundVolumeView.unMute(
                                              soundVolumeView
                                                  .applicationDevices[index]);
                                        } else {
                                          await soundVolumeView.mute(
                                              soundVolumeView
                                                  .applicationDevices[index]);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height: 90,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        items: soundVolumeView.outputDevices
                                            .map((output) => DropdownMenuItem(
                                                  value: output.itemID,
                                                  child: Text(output.name!),
                                                ))
                                            .toList(),
                                        onChanged: (String? value) async {
                                          final device = soundVolumeView
                                              .outputDevices
                                              .firstWhere((element) =>
                                                  element.itemID == value);
                                          await soundVolumeView.setAppDefault(
                                              soundVolumeView
                                                  .applicationDevices[index],
                                              device,
                                              defaultType: DefaultType.all);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.green.shade100,
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text('Output devices'),
                            subtitle:
                                Text('Output devices found on your system'),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController3,
                              itemCount: soundVolumeView.outputDevices.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) =>
                                  Card(
                                      child: ListTile(
                                title: Text(
                                    soundVolumeView.outputDevices[index].name!),
                                subtitle: Text(soundVolumeView
                                    .outputDevices[index].deviceName!),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      icon: soundVolumeView
                                                  .outputDevices[index].muted ==
                                              'Yes'
                                          ? const Icon(Icons.volume_off,
                                              color: Colors.red)
                                          : const Icon(Icons.volume_up,
                                              color: Colors.green),
                                      onPressed: () async {
                                        if (soundVolumeView
                                                .outputDevices[index].muted ==
                                            'Yes') {
                                          await soundVolumeView.unMute(
                                              soundVolumeView
                                                  .outputDevices[index]);
                                        } else {
                                          await soundVolumeView.mute(
                                              soundVolumeView
                                                  .outputDevices[index]);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 90,
                                      child:
                                          DropdownButtonFormField<DefaultType>(
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem<DefaultType>(
                                            value: null,
                                            child: Text(''),
                                          ),
                                          DropdownMenuItem<DefaultType>(
                                            value: DefaultType.all,
                                            child: Text('All'),
                                          ),
                                          DropdownMenuItem<DefaultType>(
                                            value: DefaultType.communications,
                                            child: Text('Communications'),
                                          ),
                                          DropdownMenuItem<DefaultType>(
                                            value: DefaultType.console,
                                            child: Text('Console'),
                                          ),
                                          DropdownMenuItem<DefaultType>(
                                            value: DefaultType.multimedia,
                                            child: Text('Multimedia'),
                                          ),
                                        ],
                                        onChanged:
                                            (DefaultType? defaultType) async {
                                          if (defaultType is DefaultType) {
                                            await soundVolumeView.setDefault(
                                                soundVolumeView
                                                    .outputDevices[index],
                                                defaultType: defaultType);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}