//
//  PMLocationManager.m
//  定位管理器
//
//  Created by majian on 15/9/30.
//  Copyright © 2015年 majian. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "PMLocationManager.h"

@interface PMLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager * sysLocationManager;
@property (nonatomic,strong) CLGeocoder * sysGeocoder;

/* Private Method */
- (void)notificateDelegateWithFailType:(PMLocationManagerFailType)failType;
- (void)notificateDelegateWithAddress:(NSString *)address;
- (void)notificateDelegateWithLocation:(CLLocation *)location;
@end

@implementation PMLocationManager
#pragma mark - Life Cycle
- (void)dealloc {
    [self.sysLocationManager stopUpdatingLocation];
}

#pragma mark - Public Method
- (void)startLocate {
    [self.sysLocationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
            
        case kCLAuthorizationStatusDenied://没有权限
            [self notificateDelegateWithFailType:PMLocationManagerFailTypeNoAuth];
            break;
            
        case kCLAuthorizationStatusRestricted://有限制
            [self notificateDelegateWithFailType:PMLocationManagerFailTypeRestricted];
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            [self startLocate];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * location = [locations lastObject];
    
    [self notificateDelegateWithLocation:location];
    
    typeof(self) sSelf = self;
    [self.sysGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        typeof(sSelf) wSelf = sSelf;
        if (error || placemarks.count == 0) {
            [wSelf notificateDelegateWithFailType:PMLocationManagerFailTypeNoNetwork];
        } else {
            [wSelf notificateDelegateWithAddress:placemarks.firstObject.locality];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self notificateDelegateWithFailType:PMLocationManagerFailTypeNoAuth];
}

#pragma mark - Private Method
- (void)notificateDelegateWithFailType:(PMLocationManagerFailType)failType {
    if (nil == self.delegate) {
        return;
    }
    
    if (![self.delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
        return;
    }
    
    [self.delegate locationManager:self
           faildLocateWithFailType:failType];
}

- (void)notificateDelegateWithAddress:(NSString *)address {
    if (nil == self.delegate) {
        return;
    }
    
    if (![self.delegate respondsToSelector:@selector(locationManager:didLocateAddress:)]) {
        return;
    }
    
    [self.delegate locationManager:self
                  didLocateAddress:address];
}

- (void)notificateDelegateWithLocation:(CLLocation *)location {
    if (nil == self.delegate) {
        return;
    }
    
    if (![self.delegate respondsToSelector:@selector(locationManager:didLocateAddress:)]) {
        return;
    }
    
    [self.delegate locationManager:self
            didSuccessWithLocation:location];
}

#pragma mark - Property Getter
- (CLLocationManager *)sysLocationManager {
    if (_sysLocationManager) {
        return _sysLocationManager;
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _sysLocationManager.distanceFilter = 1000;
        
        //在ios 8.0下要授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [_sysLocationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        }
    }

    return _sysLocationManager;
}

- (CLGeocoder *)sysGeocoder {
    if (_sysGeocoder) {
        return _sysGeocoder;
    }
    
    _sysGeocoder = [[CLGeocoder alloc] init];
    
    return _sysGeocoder;
}

@end
