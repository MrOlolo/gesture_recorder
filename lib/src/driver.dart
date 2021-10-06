import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

import 'timeline_pointer_data.dart';

/// Adaptor to `flutter_driver`
void recorderDriver(Duration recordTime,
    [String sessionName = 'record_gesture']) {
  group(sessionName, () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver!.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) driver!.close();
    });

    test('Record gestures for ${recordTime.inSeconds} seconds:', () async {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await driver!.forceGC();
      Timer? timer;
      final Timeline timeline = await driver!.traceAction(() async {
        print('${recordTime.inSeconds} seconds left');
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          print('${recordTime.inSeconds - timer.tick} seconds left');
        });
        await Future<void>.delayed(recordTime);
      });
      timer?.cancel();
      final PointerDataRecord inputEvents =
          PointerDataRecord.filterFrom(timeline);
      inputEvents.writeToFile(sessionName, pretty: true, asDart: true);
    });
  });
}
