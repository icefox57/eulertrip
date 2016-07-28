//
//  GlobalVariables.m
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//

#import "Foundation.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"

@implementation GlobalVariables

static GlobalVariables *_instance            = nil;
static AMapLocationManager *_locationManager = nil;

#define DefaultLocationTimeout  10
#define DefaultReGeocodeTimeout 5

+ (AMapLocationManager *)locationManager
{
    if (_locationManager != nil) {
        return _locationManager;
    }
    
    _locationManager = [[AMapLocationManager alloc] init];
    
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [_locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [_locationManager setLocationTimeout:DefaultLocationTimeout];
    
    [_locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    return _locationManager;
}

+ (GlobalVariables *)shareGlobalVariables
{
    if (_instance == nil)
    {
        _instance = [[GlobalVariables alloc] init];
    }
    
    return _instance;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image
{
    CGSize newSize = CGSizeMake(image.size.width/3, image.size.height/3);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - DB
+ (NSString *)stringToBase64String:(NSString *)str{
    
    NSData* sampleData = [str dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString * base64String = [sampleData base64EncodedStringWithOptions:0];
    //    NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    //    NSLog(@"decode String is %@",[NSString stringWithUTF8String:[dataFromString bytes]]);
    return base64String;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return [self stringFromDate:date format:@"yyyy-MM-dd"];
}

#pragma mark - Alert

+(UIAlertController *)addAlertBy:(NSString *)alertString
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertString
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

#pragma mark common

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
