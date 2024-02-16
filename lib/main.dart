import 'package:flutter/material.dart';
import 'package:test_app/about/about_screen.dart';
import 'package:test_app/experiments/experiments_screen.dart';
import 'package:test_app/map/map_screen.dart';
import 'dart:async';

import 'package:yandex_maps/init.dart' as init;
import 'package:yandex_maps/mapkit_factory.dart';
import 'package:yandex_maps/runtime.dart';

class NamedScreenButton extends StatelessWidget {
  const NamedScreenButton(
      {required this.name, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 100,
        child: TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => builder(context))),
            child: Text(
              name,
              textScaleFactor: 1.5,
            )));
  }

  final String name;
  final Widget Function(BuildContext context) builder;
}

const String environment = 'production';
const String environmentKey = 'yandex.maps.runtime.hosts.Env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.mapsInit(
      onInit: () {
        mapkit.setApiKey(key: "YOUR_API_KEY");
      },
      options: {environmentKey: environment});

  Runtime.setFailedAssertionListener(FailedAssertionListener(
      onFailedAssertion: (file, line, condition, message, stack) {
    print('Error on $file:$line $condition $message\n$stack');
  }));

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {}

  static AboutScreen createAbout(BuildContext _) {
    return const AboutScreen();
  }

  static ExperimentsScreen createExperiments(BuildContext _) {
    return const ExperimentsScreen();
  }

  static MapScreen createMap(BuildContext _) {
    return const MapScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: const Column(
            children: [
              NamedScreenButton(name: 'About', builder: createAbout),
              NamedScreenButton(name: 'Experiments', builder: createExperiments),
              NamedScreenButton(name: "Map", builder: createMap),
            ],
          )),
    );
  }
}
