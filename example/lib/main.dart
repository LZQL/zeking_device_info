import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zeking_device_info/zeking_device_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String devicesName;
  String systemName;
  String systemVersion;
  bool isPhysicalDevice;
  num lateralResolution;
  num verticalResolution;
  String model;
  double deviceInch;
  String onlyCode;
  String uuid;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState()  {
    Zekingdeviceinfo.getDevicesInfo('ZekingDeviceInfoExample').then((info){
      setState(() {
        this.devicesName = info.devicesName;
        this.systemName = info.systemName;
        this.systemVersion = info.systemVersion;
        this.isPhysicalDevice = info.isPhysicalDevice;
        this.lateralResolution = info.lateralResolution;
        this.verticalResolution = info.verticalResolution;
        this.model = info.model;
        this.deviceInch = info.deviceInch;
        this.onlyCode = info.onlyCode;
        this.uuid = info.uuid;
      });
    });





  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zeking Device Info'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Text('手机名：$devicesName'),
            Text('系统名：$systemName'),
            Text('系统版本：$systemVersion'),
            Text('是否是真机：$isPhysicalDevice'),
            Text('横向分辨率：$lateralResolution'),
            Text('竖向分辨率：$verticalResolution'),
            Text('型号：$model'),
            Text('尺寸：$deviceInch'),
            Text('设备唯一码：$onlyCode'),
            Text('UUID -> IOS独有：$uuid'),
          ],
        ),
      ),
    );
  }
}
