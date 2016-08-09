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


#pragma mark - animation handle

+(void)addGradientAnimation:(UIView *)view{
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.frame = view.bounds;
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor whiteColor].CGColor,
                   (__bridge id)[UIColor clearColor].CGColor,
                   nil];
    mask.startPoint = CGPointMake(0, .5); // middel left
    mask.endPoint = CGPointMake(1, .5); // middel right
    view.layer.mask = mask;
    ((CAGradientLayer *)view.layer.mask).locations = @[@0,@0];
}

+(void)startGradinentAnimation:(UIView *)view duration:(NSTimeInterval)duration{
    view.alpha = 1;
    
    [UIView animateWithDuration:duration animations:^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        
        ((CAGradientLayer *)view.layer.mask).locations = @[@1,@1];
        
        [CATransaction commit];
    } completion:^(BOOL finished) {
    }];
}

+(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

+(void)scaleView:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}


@end
