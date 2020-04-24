//
//  ZekingDeviceInfoModel.h
//  MJExtension
//
//  Created by 李樟清 on 2020/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZekingDeviceInfoModel : NSObject

@property(nonatomic) NSString *devicesName;         // 手机名
@property(nonatomic) NSString *systemName;          // 系统名
@property(nonatomic) NSString *systemVersion;       // 系统版本
@property(nonatomic) bool isPhysicalDevice;         // 是否是真机
@property(nonatomic) double lateralResolution;      // 横向分辨率
@property(nonatomic) double verticalResolution;     // 竖向分辨率
@property(nonatomic) NSString *model;               // 型号
@property(nonatomic) double deviceInch;             // 尺寸
@property(nonatomic) NSString *onlyCode;            // 设备唯一码
@property(nonatomic) NSString *uuid;                // UUID



@end

NS_ASSUME_NONNULL_END
