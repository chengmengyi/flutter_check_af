import 'package:flutter_check_af/dio/dio_hep.dart';
import 'package:flutter_check_af/flutter_check_af.dart';
import 'package:flutter_check_af/request_cloak/request_cloak_callback.dart';

class RequestCloak{
  String url;
  Map<String,dynamic> data;
  String whiteKey;
  RequestCloakCallback requestCloakCallback;

  var _firstRequest=true,clockIsWhite=false;
  Function()? aPackageCall;

  RequestCloak({
    required this.url,
    required this.data,
    required this.whiteKey,
    required this.requestCloakCallback,
  });

  init()async{
    if(_firstRequest){
      requestCloakCallback.startRequestCloak.call();
      _firstRequest=false;
    }
    FlutterCheckAf.instance.log("check user---> start request cloak--->url:$url---->data:$data");
    var dioResult = await DioHep.instance.requestPost(path: url, data: data);
    FlutterCheckAf.instance.log("check user---> request cloak result--->result:${dioResult.success}---->msg:${dioResult.msg}");
    if(dioResult.success){
      clockIsWhite=dioResult.msg==whiteKey;
      requestCloakCallback.requestSuccess.call(clockIsWhite);
      aPackageCall?.call();
    }else{
      await Future.delayed(const Duration(milliseconds: 1000));
      init();
    }
  }

  setAPackageCloakCall(Function() call){
    aPackageCall=call;
  }
}