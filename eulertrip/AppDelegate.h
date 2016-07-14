//
//  AppDelegate.h
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,MBProgressHUDDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (strong, nonatomic) BMKMapManager* mapManager;

-(void)showLoadingHUD:(NSString *)text view:(UIView *)view;
@end

