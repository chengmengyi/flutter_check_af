
import 'package:appsflyer_sdk_plus/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_af/request_af/request_af.dart';
import 'package:flutter_check_af/request_cloak/request_cloak.dart';
import 'package:flutter_check_af/callback/request_callback.dart';
import 'package:flutter_check_af/request_referrer/request_referrer.dart';
import 'package:flutter_check_af/storage/storage_hep.dart';

class FlutterCheckAf {
  static final FlutterCheckAf _instance = FlutterCheckAf();
  static FlutterCheckAf get instance => _instance;

  RequestAf? _requestAf;
  RequestCloak? _requestCloak;
  final List<String> _referrerConfList=[];
  bool _referrerAlwaysB=false;

  init({
    required String afKey,
    required String afAppId,
    required String distinctId,
    required String clockUrl,
    required String cloakWhiteKey,
    required Map<String,dynamic> cloakData,
    required RequestCallback requestCallback,
  }){
    _requestAf=RequestAf(afKey: afKey, afAppId: afAppId, distinctId: distinctId, requestCallback: requestCallback);
    _requestCloak=RequestCloak(url: clockUrl, data: cloakData, whiteKey: cloakWhiteKey, requestCallback: requestCallback);
    _requestAf?.init();
    _requestCloak?.init();
    RequestReferrer(requestCallback: requestCallback).init();
  }

  bool checkUser(){
    if(AfStorageHep.instance.getLocalIsB()){
      log("check user---> checkUser --->local is b");
      return true;
    }
    if(_requestCloak?.clockIsWhite!=true){
      log("check user---> checkUser --->cloak is black");
      return false;
    }
    if(_requestAf?.afIsB!=true&&!_checkReferrerBuyUser()){
      log("check user---> checkUser ---> af is a");
      return false;
    }
    log("check user---> checkUser ---> is b");
    AfStorageHep.instance.saveUser(true);
    return true;
  }

  bool _checkReferrerBuyUser(){
    final referrer=AfStorageHep.instance.getLocalReferrerStr();
    if(_referrerAlwaysB) return true;
    if(_referrerConfList.isEmpty) return referrer.contains('adjust');
    return _referrerConfList.any(referrer.contains);
  }

  updateReferrerList(bool referrerAlwaysB,List<String> list){
    _referrerConfList..clear()..addAll(list);
    _referrerAlwaysB=referrerAlwaysB;
  }

  setAfCloakCallbackInAPackage({
    required Function() cloakCall,
    required Function() afCall,
  }){
    _requestAf?.setAPackageAfCall(afCall);
    _requestCloak?.setAPackageCloakCall(cloakCall);
  }

  uploadAdRevenue(String networkName,double revenue,String adId,String pointName,AFMediationNetwork mediationNetwork){
    _requestAf?.uploadAdRevenue(networkName, revenue, adId, pointName,mediationNetwork);
  }

  logEvent({
    required String eventName,
    Map? eventValues,
  }){
    _requestAf?.logEvent(eventName: eventName,eventValues: eventValues);
  }

  log(String s){
    if(kDebugMode){
      print(s);
    }
  }
}
