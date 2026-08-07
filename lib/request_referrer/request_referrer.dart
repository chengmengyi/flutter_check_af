import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter_check_af/callback/request_callback.dart';
import 'package:flutter_check_af/flutter_check_af.dart';
import 'package:flutter_check_af/storage/storage_hep.dart';

class RequestReferrer {
  int _requestNum = 0;
  final RequestCallback requestCallback;

  RequestReferrer({required this.requestCallback});

  Future<void> init() async {
    if (Platform.isIOS || _requestNum >= 15) return;
    final cached = AfStorageHep.instance.getLocalReferrerStr();
    if (cached.isNotEmpty) {
      requestCallback.requestReferrerCallback.startRequestReferrer.call();
      requestCallback.requestReferrerCallback.requestSuccess.call(cached);
      return;
    }
    try {
      if (_requestNum == 0) requestCallback.requestReferrerCallback.startRequestReferrer.call();
      final details = await AndroidPlayInstallReferrer.installReferrer;
      final referrer = details.installReferrer ?? '';
      FlutterCheckAf.instance.log('check user---> request referrer result--->$referrer');
      if (referrer.isNotEmpty) {
        requestCallback.requestReferrerCallback.requestSuccess.call(referrer);
        AfStorageHep.instance.saveLocalReferrerStr(referrer);
      } else {
        _requestNum++;
        await init();
      }
    } catch (_) {
      _requestNum++;
      await init();
    }
  }
}
