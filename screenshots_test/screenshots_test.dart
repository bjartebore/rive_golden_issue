import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:rive_issue/main.dart';

final _testStartTime = Clock.fixed(DateTime(2024, 1, 1, 12));

void main() {
  testGoldens('Create screensh ots', (WidgetTester tester) async {
    await withClock(_testStartTime, () async {
      await tester.pumpWidget(const MyApp());

      Future<void> handleDeviceSetup(Device device, WidgetTester tester) async {
        final split = device.name.split("/");

        if (split.length == 2) {
          WidgetsBinding.instance.performReassemble();

          await tester.pump(const Duration(seconds: 16));
        }
      }

      await tester.pump(const Duration(seconds: 1));

      await multiScreenGolden(
        tester,
        'main',
        deviceSetup: handleDeviceSetup,
        customPump: (tester) async {},
      );
    });
  }, tags: ["screenshots"]);
}
