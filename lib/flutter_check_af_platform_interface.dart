import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_check_af_method_channel.dart';

abstract class FlutterCheckAfPlatform extends PlatformInterface {
  /// Constructs a FlutterCheckAfPlatform.
  FlutterCheckAfPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCheckAfPlatform _instance = MethodChannelFlutterCheckAf();

  /// The default instance of [FlutterCheckAfPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCheckAf].
  static FlutterCheckAfPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCheckAfPlatform] when
  /// they register themselves.
  static set instance(FlutterCheckAfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
