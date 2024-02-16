import 'package:flutter/material.dart' hide Animation, Alignment;
import 'package:yandex_maps/mapkit.dart' hide TextStyle;
import 'package:yandex_maps/mapkit_factory.dart';
import 'package:yandex_maps/search.dart';
import 'package:yandex_maps/runtime.dart';
import 'package:yandex_maps/yandex_map.dart';
import "package:yandex_maps/image.dart" as img;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen>
    with WidgetsBindingObserver
    implements
        MapCameraListener,
        MapInputListener,
        SearchResultListener {
  @override
  void initState() {
    super.initState();
    _startMapkit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _stopMapkit();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _startMapkit() {
    if (!active) {
      active = true;
      mapkit.onStart();
    }
  }

  void _stopMapkit() {
    if (active) {
      active = false;
      mapkit.onStop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startMapkit();
    } else if (state == AppLifecycleState.paused) {
      _stopMapkit();
    }
  }

  void _onMapCreated(MapWindow window) {
    final map = window.map;

    map.addCameraListener(this);
    map.addInputListener(this);
    map.move(const CameraPosition(
        Point(latitude: 55.0115145, longitude: 82.90885056),
        zoom: 8,
        azimuth: 1,
        tilt: 2));
    map.logo.setAlignment(const LogoAlignment(
        LogoHorizontalAlignment.Center, LogoVerticalAlignment.Bottom));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack(children: [
        YandexMap(
          onMapCreated: _onMapCreated,
        ),
        Text(
          _moved ? 'Moved' : 'Stopped',
          style: TextStyle(
              fontSize: 16,
              color: _moved
                  ? const Color.fromARGB(255, 10, 255, 10)
                  : const Color.fromARGB(100, 0, 0, 0)),
        )
      ]),
    );
  }

  @override
  void onCameraPositionChanged(Map map, CameraPosition cameraPosition,
      CameraUpdateReason cameraUpdateReason, bool finished) {
    if (finished) {
      setState(() {
        _moved = false;
      });
    } else if (!_moved) {
      setState(() {
        _moved = true;
      });
    }
  }

  bool _moved = false;

  void moveMap(Map map, Point target, {double seconds = 1.0}) {
    final begin = map.cameraPosition;
    final targetPosition = CameraPosition(target,
        zoom: begin.zoom, azimuth: begin.azimuth, tilt: begin.tilt);

    map.moveWithAnimation(
        targetPosition, Animation(AnimationType.Smooth, duration: seconds),
        cameraCallback:
            MapCameraCallback(onMoveFinished: (_) => print("Move finished")));
  }

  @override
  void onMapLongTap(Map map, Point point) {
    moveMap(map, point);
  }

  @override
  void onMapTap(Map map, Point point) {
    final placemark = map.mapObjects.addPlacemark()
      ..geometry = point;

    placemark.useAnimation()
      ..setIcon(
          img.AnimatedImageProvider.fromAsset('assets/new_pin.png',
              id: 'my_id'),
          const IconStyle())
      ..play();
  }

  @override
  void onAllResultsClear() {
    // TODO: implement onAllResultsClear
  }

  @override
  void onPresentedResultsUpdate() {
    // TODO: implement onPresentedResultsUpdate
  }

  @override
  void onSearchError(Error error, RequestType requestType) {
    // TODO: implement onSearchError
  }

  @override
  void onSearchStart(RequestType requestType) {
    // TODO: implement onSearchStart
  }

  @override
  void onSearchSuccess(RequestType requestType) {
    // TODO: implement onSearchSuccess
  }

  bool active = false;
}
