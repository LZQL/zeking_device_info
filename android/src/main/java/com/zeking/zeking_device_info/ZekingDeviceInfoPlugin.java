package com.zeking.zeking_device_info;


import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.Display;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
/** ZekingDeviceInfoPlugin */
public class ZekingDeviceInfoPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {


  MethodChannel channel;
  Activity activity ;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    setupMethodChannel(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());

  }

  public static void registerWith(Registrar registrar) {

    registrar.activity();

    ZekingDeviceInfoPlugin plugin = new ZekingDeviceInfoPlugin();
    plugin.setupMethodChannel(registrar.messenger(),registrar.context());

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
  }

  private void setupMethodChannel(BinaryMessenger messenger, Context context) {
    channel = new MethodChannel(messenger, "zekingdeviceinfo");
    channel.setMethodCallHandler(this);
  }

  // ============================================================================================

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity  = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  // ============================================================================================

  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  @Override
  public void onMethodCall(MethodCall call, Result result) {

    if (call.method.equals("getDeviceInfo")) {
//      Map r = getDeviceInfo();
//      if(r != null){
      result.success(getDeviceInfo());
//      }else{
//        result.error("UNAVAILABLE", "getDeviceInfo Failed", null);
//      }
    } else {
      result.notImplemented();
    }
  }

  // ============================================================================================

  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  public  String getDeviceInfo() {
    String jsonString = "";

    try {
      int realWidth = 0, realHeight = 0;

      Display display = activity.getWindowManager().getDefaultDisplay();

      DisplayMetrics metrics = new DisplayMetrics();
      display.getMetrics(metrics);
      if (android.os.Build.VERSION.SDK_INT >= 17) {
        Point size = new Point();
        display.getRealSize(size);
        realWidth = size.x;
        realHeight = size.y;
      } else if (android.os.Build.VERSION.SDK_INT < 17
              && android.os.Build.VERSION.SDK_INT >= 14) {
        Method mGetRawH = Display.class.getMethod("getRawHeight");
        Method mGetRawW = Display.class.getMethod("getRawWidth");
        realWidth = (Integer) mGetRawW.invoke(display);
        realHeight = (Integer) mGetRawH.invoke(display);
      } else {
        realWidth = metrics.widthPixels;
        realHeight = metrics.heightPixels;
      }

      double inch = formatDouble(Math.sqrt((realWidth / metrics.xdpi) * (realWidth / metrics.xdpi) + (realHeight / metrics.ydpi) * (realHeight / metrics.ydpi)), 2);

      String devicesName = Settings.Secure.getString(activity.getContentResolver(), "bluetooth_name"); // 手机名 : Honor V10            OnePlus 8
      String systemName = "Android";                                                                        // 系统名 : Android
      String systemVersion = Build.VERSION.RELEASE;                                                         // 系统版本 : 10
      boolean isPhysicalDevice = !isEmulator();                                                             // 是否是真机 ：true false
      double lateralResolution = realWidth;                                                                 // 横向分辨率
      double verticalResolution = realHeight;                                                               // 竖向分辨率
      String model = "";                                                                                    // 型号： HUAWEI BKL-AL20        OnePlus IN2010
      if(android.os.Build.BRAND.isEmpty()){
        model = android.os.Build.MANUFACTURER + " " + android.os.Build.MODEL;
      }else{
        model = android.os.Build.BRAND + " " + android.os.Build.MODEL;
      }
      String onlyCode = UniqueIDUtils.getUniqueID(activity.getApplicationContext());                        // 设备唯一码
      double deviceInch = inch;

      ZekingDeviceInfoModel zekingDeviceInfoModel = new ZekingDeviceInfoModel();
      zekingDeviceInfoModel.devicesName = devicesName;
      zekingDeviceInfoModel.systemName = systemName;
      zekingDeviceInfoModel.systemVersion = systemVersion;
      zekingDeviceInfoModel.isPhysicalDevice = isPhysicalDevice;
      zekingDeviceInfoModel.lateralResolution = lateralResolution;
      zekingDeviceInfoModel.verticalResolution = verticalResolution;
      zekingDeviceInfoModel.model = model;
      zekingDeviceInfoModel.onlyCode = onlyCode;
      zekingDeviceInfoModel.deviceInch = deviceInch;

      jsonString = new Gson().toJson(zekingDeviceInfoModel);

    } catch (Exception e) {
      e.printStackTrace();
    }

    return  jsonString;
  }

  /**
   * Double类型保留指定位数的小数，返回double类型（四舍五入）
   * newScale 为指定的位数
   */
  private static double formatDouble(double d, int newScale) {
    BigDecimal bd = new BigDecimal(d);
    return bd.setScale(newScale, BigDecimal.ROUND_HALF_UP).doubleValue();
  }

  // 是否是 模拟器
  private boolean isEmulator() {
    return (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
            || Build.FINGERPRINT.startsWith("generic")
            || Build.FINGERPRINT.startsWith("unknown")
            || Build.HARDWARE.contains("goldfish")
            || Build.HARDWARE.contains("ranchu")
            || Build.MODEL.contains("google_sdk")
            || Build.MODEL.contains("Emulator")
            || Build.MODEL.contains("Android SDK built for x86")
            || Build.MANUFACTURER.contains("Genymotion")
            || Build.PRODUCT.contains("sdk_google")
            || Build.PRODUCT.contains("google_sdk")
            || Build.PRODUCT.contains("sdk")
            || Build.PRODUCT.contains("sdk_x86")
            || Build.PRODUCT.contains("vbox86p")
            || Build.PRODUCT.contains("emulator")
            || Build.PRODUCT.contains("simulator");
  }

}
