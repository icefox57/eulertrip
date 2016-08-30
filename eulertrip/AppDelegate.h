//
//  AppDelegate.h
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MBProgressHUD.h"
#import "GlobalVariables.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) UIWindow      *window;
@property (nonatomic,retain ) MBProgressHUD *HUD;
@property (strong, nonatomic) UIView *launchView;

-(void)showLoadingHUD:(NSString *)text view:(UIView *)view;
@end

