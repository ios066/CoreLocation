//
//  ViewController.m
//  CoreLocation
//
//  Created by ioswei on 15/6/4.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

/**
 *  CoreLocation管理者
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 适配iOS8
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager performSelector:@selector(requestAlwaysAuthorization)];
        }
#endif
    }
    
    // 设置代理
    self.locationManager.delegate = self;
    
    // 设置获取频率
    self.locationManager.distanceFilter = 1.0f;
    
    // 设置精确度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 开始获取
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

/**
 *  获取到的位置信息
 *
 *  @param manager   CoreLocation管理者
 *  @param locations 获取的位置信息
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __func__);
    
    // 停止获取
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - 懒加载

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

@end
