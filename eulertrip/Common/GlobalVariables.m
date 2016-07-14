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

static BMKLocationService *_locService = nil;
static GlobalVariables *_instance = nil;
static CLLocationManager *_locationManager = nil;

+ (BMKLocationService *)locService
{
    if (_locService != nil) {
        return _locService;
    }
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];

    return _locService;
}

+ (CLLocationManager *)locationManager 
{
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
	
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

#pragma mark - Error handle

+(void)handleErrorByError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

+(void)handleErrorByString:(NSString *)errorString
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}


@end
