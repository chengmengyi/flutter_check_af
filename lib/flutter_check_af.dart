
import 'package:flutter/foundation.dart';
import 'package:flutter_check_af/request_af/request_af.dart';
import 'package:flutter_check_af/request_af/request_af_callback.dart';
import 'package:flutter_check_af/request_cloak/request_cloak.dart';
import 'package:flutter_check_af/request_cloak/request_cloak_callback.dart';
import 'package:flutter_check_af/storage/storage_hep.dart';

class FlutterCheckAf {
  static final FlutterCheckAf _instance = FlutterCheckAf();
  static FlutterCheckAf get instance => _instance;

  RequestAf? _requestAf;
  RequestCloak? _requestCloak;
  String _afSwitch="1";

  init({
    required String afKey,
    required String afAppId,
    required String afSwitch,
    required String distinctId,
    required String clockUrl,
    required String cloakWhiteKey,
    required Map<String,dynamic> cloakData,
    required RequestAfCallback requestAfCallback,
    required RequestCloakCallback requestCloakCallback,
  }){
    _afSwitch=afSwitch;
    _requestAf=RequestAf(afKey: afKey, afAppId: afAppId, distinctId: distinctId, requestAfCallback: requestAfCallback);
    _requestCloak=RequestCloak(url: clockUrl, data: cloakData, whiteKey: cloakWhiteKey, requestCloakCallback: requestCloakCallback);
    _requestAf?.init();
    _requestCloak?.init();
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
    if(_afSwitch=="1"&&_requestAf?.afIsB!=true){
      log("check user---> checkUser ---> af is a");
      return false;
    }
    log("check user---> checkUser ---> is b");
    AfStorageHep.instance.saveUser(true);
    return true;
  }

  setAfCloakCallbackInAPackage({
    required Function() cloakCall,
    required Function() afCall,
  }){
    _requestAf?.setAPackageAfCall(afCall);
    _requestCloak?.setAPackageCloakCall(cloakCall);
  }

  uploadAdRevenue(String networkName,double revenue,String adId,String pointName){
    _requestAf?.uploadAdRevenue(networkName, revenue, adId, pointName);
  }

  updateAfSwitch(String afSwitch){
    _afSwitch=afSwitch;
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
