//
//  GlobalVariables.h
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "Foundation.h"
#import <BaiduMapAPI/BMapKit.h>

@interface GlobalVariables : NSObject

@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSArray *eventArray;
@property (nonatomic,retain) BMKUserLocation *userLocation;
//@property (nonatomic,retain) NSMutableArray *disNewCountArray;

+ (BMKLocationService *) locService;
+ (CLLocationManager *)locationManager;
+ (GlobalVariables *)shareGlobalVariables;

+ (UIImage*)imageWithImageSimple:(UIImage*)image;

//DB
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;

//异常处理
+(void)handleErrorByError:(NSError *)error;
+(void)handleErrorByString:(NSString *)errorString;

@end
