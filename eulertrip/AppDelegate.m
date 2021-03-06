//
//  AppDelegate.m
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "AFAppDotNetAPIClient.h"
#import "AFNetworking/AFNetworking.h"
#import "IceOAuthCredential.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize launchView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    //$$$$$$$$$
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_UserCredentialDic];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //友盟统计初始化
    UMConfigInstance.appKey    = UMAppKey;
    UMConfigInstance.channelId = AppDownloadSource;
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    //高德定位初始化
    [AMapServices sharedServices].apiKey = AmapAppKey;
    
    //获取accesstoken
    if (![IceOAuthCredential shareCredential] || [IceOAuthCredential isTokenExpires]) {
        if(![IceOAuthCredential shareCredential].refreshToken || [[IceOAuthCredential shareCredential].refreshToken isEqualToString:@""]){
#if Debug_DbInterface_Status
        NSLog(@"~~~~~~~~获取临时token~~~~~~~过期:%d",[IceOAuthCredential isTokenExpires]);
#endif
            [IceOAuthCredential getTempAccesstoken:^(id  _Nullable responseObject) {
                [self getCalendarData];
            } failure:^(id  _Nonnull errorDic) {
            }];
        }
        else{
#if Debug_DbInterface_Status
            NSLog(@"~~~~~~~~刷新用户token~~~~~~~过期:%d",[IceOAuthCredential isTokenExpires]);
#endif
            [[IceOAuthCredential shareCredential] refreshToken:^(id  _Nullable responseObject) {
                [self getCalendarData];
            } failure:^(id  _Nonnull errorDic) {
            }];
        }
    }
    else{
        [self getCalendarData];
    }
    
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)getCalendarData{
    //获取日历数据
    [[AFAppDotNetAPIClient sharedClient] performGetRequestToURL:@"v1/Common/GetCalendar" andParameters:nil success:^(id _Nullable responseObject) {
        
        if ([[responseObject objectForKey:API_ReturnDataCount]integerValue]>0) {
            NSArray *dataArray = (NSArray *)[responseObject objectForKey:API_ReturnData];
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            for (NSDictionary *dic in dataArray) {
                [dataDic setObject:[dic objectForKey:MD_Calendar_Memo] forKey:[dic objectForKey:MD_Calendar_Day]];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:dataDic forKey:UD_CalendarDataDic];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
    } failure:^(id _Nonnull errorDic) {
    }];

}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [_HUD removeFromSuperview];
    _HUD = nil;
}

-(void)showLoadingHUD:(NSString *)text view:(UIView *)view
{
    //Loading HUD
    _HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_HUD];
    _HUD.delegate   = self;
    _HUD.label.text = text;
    [_HUD showAnimated:YES];
}

@end
