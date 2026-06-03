import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android manifest declares microphone and network permissions', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();

    expect(manifest, contains('android.permission.RECORD_AUDIO'));
    expect(manifest, contains('android.permission.INTERNET'));
    expect(manifest, contains('android.permission.ACCESS_NETWORK_STATE'));
    expect(manifest, contains('android.permission.MODIFY_AUDIO_SETTINGS'));
  });

  test('Android debug builds allow local HTTP API traffic', () {
    final debugManifest = File(
      'android/app/src/debug/AndroidManifest.xml',
    ).readAsStringSync();
    final profileManifest = File(
      'android/app/src/profile/AndroidManifest.xml',
    ).readAsStringSync();

    expect(debugManifest, contains('android:usesCleartextTraffic="true"'));
    expect(profileManifest, contains('android:usesCleartextTraffic="true"'));
  });

  test('iOS Info.plist explains microphone usage', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();

    expect(plist, contains('NSMicrophoneUsageDescription'));
    expect(plist, contains('conversar em inglês com a professora IA'));
  });
}
