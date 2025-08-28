import 'package:appsflyer_sdk_plus/appsflyer_sdk.dart';
import 'package:flutter_check_af/flutter_check_af.dart';
import 'package:flutter_check_af/request_af/request_af_callback.dart';
import 'package:flutter_check_af/storage/storage_hep.dart';

class RequestAf{
  String afKey;
  String afAppId;
  String distinctId;
  RequestAfCallback requestAfCallback;

  AppsflyerSdk? _appsflyerSdk;
  Function()? aPackageAfCall;

  bool afIsB=false;

  RequestAf({
    required this.afKey,
    required this.afAppId,
    required this.distinctId,
    required this.requestAfCallback,
  });

  init()async{
    _appsflyerSdk=AppsflyerSdk(AppsFlyerOptions(
      afDevKey: afKey,
      appId: afAppId,
      timeToWaitForATTUserAuthorization: 8,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    ));
    await _appsflyerSdk?.initSdk(registerConversionDataCallback: true);
    _appsflyerSdk?.setCustomerUserId(distinctId);
    _appsflyerSdk?.onInstallConversionData((res){
      FlutterCheckAf.instance.log("check user---> request af result-->$res");
      try{
        if(res["status"]=="success"){
          var status = res["payload"]["af_status"].toString();
          var isB = !status.contains("Organic");
          afIsB=true;
          requestAfCallback.requestSuccess.call(afIsB);
          if(isB){
            if(AfStorageHep.instance.getAfResult().isEmpty){
              requestAfCallback.firstRequestAfB.call();
              AfStorageHep.instance.saveAfResult(status);
            }
            aPackageAfCall?.call();
          }
        }
      }catch(e){

      }
    });

    requestAfCallback.startRequestAf.call();
    _startAf();
  }

  _startAf(){
    FlutterCheckAf.instance.log("check user---> start request af");
    _appsflyerSdk?.startSDK(
        onSuccess: (){
          FlutterCheckAf.instance.log("check user---> initAppsflyer success");
          requestAfCallback.startAfSuccess.call();
        },
        onError: (code,msg){
          FlutterCheckAf.instance.log("check user---> initAppsflyer fail--->$code---->$msg");
          requestAfCallback.startAfFail.call(code,msg);
          Future.delayed(const Duration(milliseconds: 1000),(){
            _startAf();
          });
        }
    );
  }

  setAPackageAfCall(Function() call){
    aPackageAfCall=call;
  }

  uploadAdRevenue(String networkName,double revenue,String adId,String pointName){
    FlutterCheckAf.instance.log("check user---> logAdRevenue--->networkName:$networkName--revenue:$revenue--adId:$adId--pointName:$pointName");
    _appsflyerSdk?.logAdRevenue(
        AdRevenueData(
            monetizationNetwork: networkName,
            mediationNetwork: AFMediationNetwork.applovinMax.value,
            currencyIso4217Code: "USD",
            revenue: revenue,
            additionalParameters: {
              "adRevenueUnit": adId,
              "adRevenuePlacement": pointName,
            }
        )
    );
  }

  logEvent({
    required String eventName,
    Map? eventValues,
})async{
    FlutterCheckAf.instance.log("check user---> logEvent--->params--->networkName:$eventName-->eventValues:$eventValues");
    var result = await _appsflyerSdk?.logEvent(eventName, eventValues);
    FlutterCheckAf.instance.log("check user---> logEvent--->result:$result---->networkName:$eventName-->eventValues:$eventValues");

  }
}