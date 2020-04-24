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
    if ([name containsString:@"iPhone 4"]) {
//        return @"3.5英寸";
        return 3.5;
    } else if([name containsString:@"iPhone 5"] || [name containsString:@"iPhone SE"]) {
//        return @"4英寸";
        return 4;
    } else if ([name containsString:@"Plus"] || [name containsString:@"plus"]){
//        return @"5.5英寸";
        return 5.5;
    }else if ([name isEqualToString:@"iPhone X"] || [name isEqualToString:@"iPhone XS"] || [name isEqualToString:@"iPhone 11 Pro"]){
//        return @"5.8英寸";
        return 5.8;
    }else if ([name containsString:@"iPhone XS Max"] || [name containsString:@"iPhone 11 Pro Max"]){
//        return @"6.5英寸";
        return 6.5;
    }else if ([name containsString:@"iPhone XR"] || [name isEqualToString:@"iPhone 11"]){
//        return @"6.1英寸";
        return 6.1;
    }else{
//        return @"4.7英寸";
        return 4.7;
    }
}

//获取设备型号
-(NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
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
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
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
