import 'dart:async';
import 'dart:ui';
import 'package:change_case/change_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

extension DeviceExtension on Device {
  Device withLocale(Locale locale) {
    return copyWith(name: '${locale.toLanguageTag()}/$name');
  }
}

extension DeviceListExtension on List<Device> {
  List<Device> withLocales(List<Locale> locales) {
    return fold([], (devices, device) {
      final localizedDevices = locales.map(device.withLocale);
      return [...devices, ...localizedDevices];
    });
  }
}

const devices = [
  Device(
    name: "android 7",
    size: Size(1107 / 3, 1968 / 3),
    textScale: 1,
    devicePixelRatio: 3,
  ),
  Device(
    name: "android tablet 7 inch",
    size: Size(800, 1280),
    textScale: 1,
    devicePixelRatio: 3,
  ),
  Device(
    name: "android tablet 10 inch",
    size: Size(1080, 1960),
    textScale: 1,
    devicePixelRatio: 3,
  ),
  Device(
    name: "iphone 6.7",
    size: Size(1290 / 3, 2796 / 3),
    textScale: 1,
    devicePixelRatio: 3,
  ),
  Device(
    name: "iphone 6.5",
    size: Size(1242 / 3, 2688 / 3),
    textScale: 1,
    devicePixelRatio: 3,
  ),
  Device(
    name: "iphone 5.5",
    size: Size(1242 / 3, 2208 / 3),
    textScale: 1,
    devicePixelRatio: 3,
  ),
];

String normalizeLanguage(String lang) {
  return switch (lang) {
    "nb-NO" => "no",
    _ => lang,
  };
}

String? getPlatform(String name) {
  if (name.contains("android")) {
    return "android";
  }
  if (name.contains("iphone")) {
    return "ios";
  }
  return null;
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();

  return await GoldenToolkit.runWithConfiguration(
    testMain,
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
      deviceFileNameFactory: (name, device) {
        final split = device.name.split("/");

        final platform = getPlatform(device.name);
        final basePath = platform == null ? "../screenshots" : "../screenshots/$platform";

        if (split.length == 2) {
          return '$basePath/${normalizeLanguage(split[0])}/$name.${split[1].toSnakeCase()}.png';
        }

        return '$basePath/$name.${device.name.toSnakeCase()}.png';
      },
      fileNameFactory: (name) {
        return '../screenshots/$name.png';
      },
      defaultDevices: devices.withLocales([const Locale('nb', "NO"), const Locale('en', 'GB')]),
    ),
  );
}
