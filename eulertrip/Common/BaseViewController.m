//
//  BaseViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/8/3.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)needLogin{
    if ([IceOAuthCredential isNeedLogin]) {
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:NO];
        return YES;
    }
    return NO;
}

@end
