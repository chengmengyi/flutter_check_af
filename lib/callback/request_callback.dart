import 'package:flutter_check_af/request_af/request_af_callback.dart';
import 'package:flutter_check_af/request_cloak/request_cloak_callback.dart';
import 'package:flutter_check_af/request_referrer/request_referrer_callback.dart';

class RequestCallback {
  final RequestAfCallback requestAfCallback;
  final RequestCloakCallback requestCloakCallback;
  final RequestReferrerCallback requestReferrerCallback;

  const RequestCallback({
    required this.requestAfCallback,
    required this.requestCloakCallback,
    required this.requestReferrerCallback,
  });
}
