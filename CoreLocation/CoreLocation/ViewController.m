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

/**
 *  上一次的位置信息
 */
@property (nonatomic, strong) CLLocation *previousLocation;

/**
 *  总路程
 */
@property (nonatomic, assign) CLLocationDistance sumDistance;

/**
 *  总时间
 */
@property (nonatomic, assign) NSTimeInterval sumTime;

@property (nonatomic, weak) IBOutlet UILabel *label;

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
    CLLocation *newLocation = [locations lastObject];
    
    if (self.previousLocation != nil) {
        // 计算距离
        CLLocationDistance distance = [newLocation distanceFromLocation:self.previousLocation];
        
        // 计算时间
        NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.previousLocation.timestamp];
        
        // 计算速度
        CGFloat speed = distance / dTime;

        // 累加时间
        self.sumTime += dTime;
        
        // 累加距离
        self.sumDistance += distance;
        
        // 计算平均速度
        CGFloat avgSpeed = self.sumDistance / self.sumTime;
        
        self.label.text = [NSString stringWithFormat:@"您的移动速度：%f 您的移动距离：%f 您的平均速度%f", speed, self.sumDistance, avgSpeed];
    }
    
    self.previousLocation = newLocation;
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
