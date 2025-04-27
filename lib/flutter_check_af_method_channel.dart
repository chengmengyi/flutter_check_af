import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_check_af_platform_interface.dart';

/// An implementation of [FlutterCheckAfPlatform] that uses method channels.
class MethodChannelFlutterCheckAf extends FlutterCheckAfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_check_af');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
