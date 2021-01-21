#import "ZekingDeviceInfoPlugin.h"

#import "sys/utsname.h"
#import "SSKeychain.h"
#import "MJExtension.h"
#import "ZekingDeviceInfoModel.h"


@implementation ZekingDeviceInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zekingdeviceinfo"
            binaryMessenger:[registrar messenger]];
  ZekingDeviceInfoPlugin* instance = [[ZekingDeviceInfoPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getDeviceInfo" isEqualToString:call.method]) {
      [self getDeviceInfo:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)getDeviceInfo:(FlutterMethodCall*)call result:(FlutterResult)result{
    
    NSString* appName = [call arguments][@"appName"];  // 获取设备唯一码的标示,可以用appName来做标识
    
    UIDevice* device = [UIDevice currentDevice];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat screenX = screenSize.width * scale;
    CGFloat screenY = screenSize.height * scale;
    
    ZekingDeviceInfoModel* model = [[ZekingDeviceInfoModel alloc] init];
    model.devicesName = [device name];
    model.systemName = [device systemName];
    model.systemVersion = [device systemVersion];
    model.isPhysicalDevice = [self isPhysicalDevice];
    model.lateralResolution = screenX;
    model.verticalResolution = screenY;
    model.model = [self getDeviceName];
    model.deviceInch = [self getDeviceInch];
    model.onlyCode = [self getOnlyCode:appName];
    model.uuid =UIDevice.currentDevice.identifierForVendor.UUIDString;
    
    NSString* json = [model mj_JSONString];
    
    result(json);
    
//    result(@{
//        @"devicesName":[device name],                   // 手机名 ：XXX 的 iPhone
//        @"systemName":[device systemName],              // 系统名 : iOS
//        @"systemVersion":[device systemVersion],        // 系统版本 : 13.1
//        @"isPhysicalDevice":@(),    // 是否是真机 ：true false
//        @"lateralResolution":@(screenX) ,               // 横向分辨率
//        @"verticalResolution":@(screenY) ,              // 竖向分辨率
//        @"model":[self getDeviceName],                  // 型号： iPhone 6s plus
//        @"deviceInch":[self getDeviceInch],             // 尺寸 ： 4.7
//        @"onlyCode":[self getOnlyCode:appName],         // 设备唯一码
//        @"uuid":UIDevice.currentDevice.identifierForVendor.UUIDString // UUID
//           });
}


// return value is false if code is run on a simulator
// 判断是不是 真机
- (bool)isPhysicalDevice {
#if TARGET_OS_SIMULATOR
  bool isPhysicalDevice = false;
#else
  bool isPhysicalDevice = true;
#endif

  return isPhysicalDevice;
}

//获取屏幕英寸
-(double)getDeviceInch{
    NSString *name = [self getDeviceName];
//    if ([name containsString:@"iPhone 4"]) {
////        return @"3.5英寸";
//        return 3.5;
//    } else if([name containsString:@"iPhone 5"] || [name containsString:@"iPhone SE"]) {
////        return @"4英寸";
//        return 4;
//    } else if ([name containsString:@"Plus"] || [name containsString:@"plus"]){
////        return @"5.5英寸";
//        return 5.5;
//    }else if ([name isEqualToString:@"iPhone X"] || [name isEqualToString:@"iPhone XS"] || [name isEqualToString:@"iPhone 11 Pro"]){
////        return @"5.8英寸";
//        return 5.8;
//    }else if ([name containsString:@"iPhone XS Max"] || [name containsString:@"iPhone 11 Pro Max"]){
////        return @"6.5英寸";
//        return 6.5;
//    }else if ([name containsString:@"iPhone XR"] || [name isEqualToString:@"iPhone 11"]){
////        return @"6.1英寸";
//        return 6.1;
//    }else{
////        return @"4.7英寸";
//        return 4.7;
//    }  参考 https://www.jianshu.com/p/203bd0f22762
    
    if([name isEqualToString:@"iPhone"]
       || [name isEqualToString:@"iPhone 3G"]
       || [name isEqualToString:@"iPhone 3GS"]
       || [name isEqualToString:@"iPhone 4"]
       || [name isEqualToString:@"iPhone 4S"]
       ){
        return 3.5;
    } else if([name isEqualToString:@"iPhone 5"]
       || [name isEqualToString:@"iPhone 5c"]
       || [name isEqualToString:@"iPhone 5s"]
       || [name isEqualToString:@"iPhone SE (1st generation)"]
       ){
       return 4;
    } else if([name isEqualToString:@"iPhone 6"]
              || [name isEqualToString:@"iPhone 6s"]
              || [name isEqualToString:@"iPhone 7"]
              || [name isEqualToString:@"iPhone 8"]
              ){
        return 4.7;
    } else if([name isEqualToString:@"iPhone 6"]
              || [name isEqualToString:@"iPhone 6s"]
              || [name isEqualToString:@"iPhone 7"]
              || [name isEqualToString:@"iPhone 8"]
              || [name isEqualToString:@"iPhone SE (2nd generation)"]
              ){
        return 4.7;
    } else if([name isEqualToString:@"iPhone 6 Plus"]
              || [name isEqualToString:@"iPhone 6s Plus"]
              || [name isEqualToString:@"iPhone 7 plus"]
              || [name isEqualToString:@"iPhone 8 Plus"]
              ){
        return 5.5;
    } else if([name isEqualToString:@"iPhone X"]
              || [name isEqualToString:@"iPhone XS"]
              || [name isEqualToString:@"iPhone 11 Pro"]
              ){
        return 5.8;
    } else if([name isEqualToString:@"iPhone XS Max"]
              || [name isEqualToString:@"iPhone 11 Pro Max"]
              ){
        return 6.5;
    } else if([name isEqualToString:@"iPhone XR"]
              || [name isEqualToString:@"iPhone 11"]
              || [name isEqualToString:@"iPhone 12"]
              || [name isEqualToString:@"iPhone 12 Pro"]
              ){
        return 6.1;
    } else if([name isEqualToString:@"iPhone 12 Pro Max"]){
        return 6.7;
    } else if([name isEqualToString:@"iPhone 12 mini"]){
        return 5.4;
    } else {
        return 4.7;
    }
}

//获取设备型号
-(NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // https://www.theiphonewiki.com/wiki/Models
    
    // iPhone
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE (1st generation)";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 plus";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
//    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
//    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
//    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
//    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE (2nd generation)";
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    
    // iPod
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod touch";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod touch (2nd generation) ";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod touch (3rd generation) ";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod touch (4th generation)";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod touch (5th generation)";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod touch (6th generation)";
    if ([deviceModel isEqualToString:@"iPod9,1"])      return @"iPod touch (7th generation)";
    
    // iPad
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad (4th generation)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad (4th generation)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad (4th generation)";
    if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad (5th generation)";
    if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad (5th generation)";
    if ([deviceModel isEqualToString:@"iPad7,5"])      return @"iPad (6th generation)";
    if ([deviceModel isEqualToString:@"iPad7,6"])      return @"iPad (6th generation)";
    if ([deviceModel isEqualToString:@"iPad7,11"])      return @"iPad (7th generation)";
    if ([deviceModel isEqualToString:@"iPad7,12"])      return @"iPad (7th generation)";
    if ([deviceModel isEqualToString:@"iPad11,6"])      return @"iPad (8th generation)";
    if ([deviceModel isEqualToString:@"iPad11,7"])      return @"iPad (8th generation)";
    
    // iPad Air
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad11,3"])      return @"iPad Air (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad11,4"])      return @"iPad Air (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad13,1"])      return @"iPad Air (4rd generation)";
    if ([deviceModel isEqualToString:@"iPad13,2"])      return @"iPad Air (4rd generation)";
    
    // iPad Pro
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro (12.9-inch)";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro (12.9-inch)";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro (9.7-inch)";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro (9.7-inch)";
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro (12.9-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro (12.9-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro (10.5-inch)";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro (10.5-inch)";
    if ([deviceModel isEqualToString:@"iPad8,1"])      return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,2"])      return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,3"])      return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,4"])      return @"iPad Pro (11-inch)";
    if ([deviceModel isEqualToString:@"iPad8,5"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,6"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,7"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,8"])      return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceModel isEqualToString:@"iPad8,9"])      return @"iPad Pro (11-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad8,10"])      return @"iPad Pro (11-inch) (2nd generation)";
    if ([deviceModel isEqualToString:@"iPad8,11"])      return @"iPad Pro (12.9-inch) (4th generation)";
    if ([deviceModel isEqualToString:@"iPad8,12"])      return @"iPad Pro (12.9-inch) (4th generation)";
    
    // iPad mini
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    if ([deviceModel isEqualToString:@"iPad11,1"])      return @"iPad mini (5th generation)";
    if ([deviceModel isEqualToString:@"iPad11,2"])      return @"iPad mini (5th generation)";
    
    // Apple TV
    if ([deviceModel isEqualToString:@"AppleTV1,1"])      return @"Apple TV (1st generation)";
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV (2st generation)";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV (3st generation)";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV (3st generation)";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV (4st generation)";
    if ([deviceModel isEqualToString:@"AppleTV6,2"])      return @"Apple TV 4K";
    
    // AirPods
    if ([deviceModel isEqualToString:@"AirPods1,1"])      return @"AirPods (1st generation)";
    if ([deviceModel isEqualToString:@"AirPods2,1"])      return @"AirPods (2nd generation)";
    if ([deviceModel isEqualToString:@"iProd8,1 "])      return @"AirPods Pro";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"iPhone Simulator 32-bit";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"iPhone Simulator 64-bit";
    
    return deviceModel;
}


// 获取设备唯一码
-(NSString *) getOnlyCode:(NSString*)service{
    
    if(service == nil || [service isEqualToString:@""] ){
        service = @"AppName";
    }
    
//    NSString * service = @"AppName";
    NSString * account = @"DeviceIdentifier";
    NSString * str = [SSKeychain passwordForService:service account:account];
    if (str && str.length > 0) {
        NSLog(@"only id ： %@", str);
    } else {
        str = UIDevice.currentDevice.identifierForVendor.UUIDString;
        [SSKeychain setPassword:str forService:service account:account];
        NSLog(@"only id ： %@", str);
    }

    return str;
}

@end
