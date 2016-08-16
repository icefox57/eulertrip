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
#import <AMapLocationKit/AMapLocationKit.h>
#import "DLUDID.h"

@interface GlobalVariables : NSObject
@property (nonatomic,retain) NSString   *userCity;
@property (nonatomic,retain) NSString   *userProvince;
@property (nonatomic,retain) NSString   *location;
@property (nonatomic,retain) NSArray    *eventArray;
@property (nonatomic,retain) CLLocation *userLocation;
//@property (nonatomic,retain) NSMutableArray *disNewCountArray;

+ (AMapLocationManager *)locationManager;
+ (GlobalVariables *)shareGlobalVariables;

+ (UIImage*)imageWithImageSimple:(UIImage*)image;

//DB
+ (NSString *)stringToBase64String:(NSString *)str;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;

//alert
+(UIAlertController *)addAlertBy:(NSString *)alertString;

//common
+ (UIImage *) createImageWithColor: (UIColor *) color;

//从左至右 渐现动画
+(void)addGradientAnimation:(UIView *)view;
+(void)startGradinentAnimation:(UIView *)view duration:(NSTimeInterval)duration;
//动画震动
+(void)shakeView:(UIView*)viewToShake;
//放大再缩小
+(void)scaleView:(UIView*)aView duration:(CGFloat)duration;
+(void)scaleView:(UIView*)aView duration:(CGFloat)duration finish:(void (^)(BOOL finished))completion;
@end
