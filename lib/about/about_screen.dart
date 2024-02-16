import 'package:flutter/material.dart' hide TextStyle;
import 'package:yandex_maps/mapkit.dart';
import 'package:yandex_maps/mapkit_factory.dart';
import 'package:yandex_maps/runtime.dart';
import 'package:yandex_maps/recording.dart';
import 'package:test_app/main.dart' as main;

import 'package:flutter/material.dart' as text_style show TextStyle;

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen>
    implements UiExperimentsListener {
  AboutScreenState();

  @override
  void initState() {
    super.initState();
    experiments = parseExperiments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
        ),
        body: DefaultTextStyle.merge(
            textAlign: TextAlign.left,
            style: const text_style.TextStyle(fontSize: 16),
            child: Column(
              children: [
                Text('Runtime version: $runtimeVersion'),
                const SizedBox(
                  height: 10,
                ),
                Text('Mapkit version: $mapkitVersion'),
                const SizedBox(
                  height: 10,
                ),
                Text('Recording version: $recordingVersion'),
                const SizedBox(
                  height: 10,
                ),
                Text('Environment: $environment'),
                const SizedBox(
                  height: 10,
                ),
                Text('Experiments:\n$experiments')
              ],
            )));
  }

  @override
  void onParametersUpdated() {
    setState(() {
      experiments = parseExperiments();
    });
  }

  String parseExperiments() {
    final ids = mapkit.mapsUiExperimentsProvider.getValue(key: 'test_buckets');

    return ids != null ? ids.split(';').join('\n') : '';
  }

  String get runtimeVersion => Runtime.version();
  String get mapkitVersion => mapkit.version;
  String get recordingVersion => RecordingFactory.instance.version;
  String get environment => main.environment;
  String experiments = '';
}
