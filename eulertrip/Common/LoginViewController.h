//
//  LoginViewController.h
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@protocol LoginViewControllerDelegate
-(void)didLoginSuccess;
@end


@interface LoginViewController : UIViewController
@property (nonatomic, weak)id<LoginViewControllerDelegate> delegate;
@end
