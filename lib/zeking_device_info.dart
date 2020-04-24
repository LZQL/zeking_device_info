import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Zekingdeviceinfo {
  static const MethodChannel _channel =
  const MethodChannel('zekingdeviceinfo');

  // 获取设备信息， appName 是为了给IOS的唯一码，做一个标识，不设置默认就是 appName 这个字符串
  static Future<ZekingDeviceInfo>  getDevicesInfo(String appName) async{

    Map<String, dynamic> params = {
      "appName": appName,
    };

    ZekingDeviceInfo info ;

    await _channel.invokeMethod('getDeviceInfo',params).then((resultJson){
      info = ZekingDeviceInfo.fromJson(jsonDecode(resultJson as String));
    });

    return info;

  }
}


class ZekingDeviceInfo{
  String devicesName;          // 手机名
  String systemName;           // 系统名
  String systemVersion;        // 系统版本
  bool isPhysicalDevice;       // 是否是真机
  num lateralResolution;    // 横向分辨率
  num verticalResolution;   // 竖向分辨率
  String model;                // 型号
  double deviceInch;           // 尺寸
  String onlyCode;             // 设备唯一码
  String uuid;                 // UUID -> IOS独有

  ZekingDeviceInfo(this.devicesName, this.systemName, this.systemVersion, this.isPhysicalDevice, this.lateralResolution, this.verticalResolution, this.model, this.deviceInch, this.onlyCode, this.uuid);

  ZekingDeviceInfo.fromJson(Map<String, dynamic> json) {
    devicesName = json['devicesName'];
    systemName = json['systemName'];
    systemVersion = json['systemVersion'];
    isPhysicalDevice = json['isPhysicalDevice'];
    lateralResolution = json['lateralResolution'];
    verticalResolution = json['verticalResolution'];
    model = json['model'];
    deviceInch = json['deviceInch'];
    onlyCode = json['onlyCode'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devicesName'] = this.devicesName;
    data['systemName'] = this.systemName;
    data['systemVersion'] = this.systemVersion;
    data['isPhysicalDevice'] = this.isPhysicalDevice;
    data['lateralResolution'] = this.lateralResolution;
    data['verticalResolution'] = this.verticalResolution;
    data['model'] = this.model;
    data['deviceInch'] = this.deviceInch;
    data['onlyCode'] = this.onlyCode;
    data['uuid'] = this.uuid;
    return data;
  }
}