//
//  PMLocationManager.h
//  定位管理器
//
//  Created by majian on 15/9/30.
//  Copyright © 2015年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger,PMLocationManagerFailType) {
    PMLocationManagerFailTypeNoAuth,//没有权限
    PMLocationManagerFailTypeRestricted,//可能是系统层面的限制
    PMLocationManagerFailTypeNoNetwork//没有网络无法反地理编址
};

@class PMLocationManager;
@protocol PMLocationManagerDelegate <NSObject>

@optional
- (void)locationManager:(PMLocationManager *)locationManager didSuccessWithLocation:(CLLocation *)location;//成功定位
- (void)locationManager:(PMLocationManager *)locationManager didLocateAddress:(NSString *)address;//成功定位并找到所在市
- (void)locationManager:(PMLocationManager *)locationManager faildLocateWithFailType:(PMLocationManagerFailType)failType;//定位或反地理编址失败

@end

@interface PMLocationManager : NSObject
/*

 注：1、   因业务需求只需要定位到坐在城市，因此delegate写的很简单，后续再加
    2、为支持iOS8及以上版本，需在Info.plist文件中添加
        <key>NSLocationWhenInUseUsageDescription</key>
        <string></string>
    3、各种考虑，决定不使用单例，如果业务需要，可以实例化一个对象，然后让appDelegate保持，使用时通过appDelegate调用即可.貌似这种情况delegate会有问题，后续解决
 */
- (void)startLocate;//开始定位

@property (nonatomic,weak) id<PMLocationManagerDelegate> delegate;



@end
