//
//  BaseViewController.h
//  eulertrip
//
//  Created by ice.hu on 16/8/3.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "MD5Util.h"
#import "AFAppDotNetAPIClient.h"
#import "IceOAuthCredential.h"

@interface BaseViewController : UIViewController

-(BOOL)needLogin;

@end
