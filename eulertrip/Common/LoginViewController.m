//
//  LoginViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalVariables.h"
#import "AFNetworking.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)loginClicked:(id)sender {
    if (!_txtUserName.text || [_txtUserName.text isEqualToString:@""]) {
        [GlobalVariables handleErrorByString:@"请输入用户名!"];
        return;
    }
    
    if (!_txtPassword.text || [_txtPassword.text isEqualToString:@""]) {
        [GlobalVariables handleErrorByString:@"请输入密码!"];
        return;
    }
    
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"act":@"UserLogin",@"jsoncallback":@"",@"name":_txtUserName.text,@"password":_txtPassword.text};
    
    [manager POST:AppDBHost parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (responseObject && [responseObject count]>0) {
            NSDictionary *dic = [(NSArray *)responseObject firstObject];
//            [GlobalVariables shareGlobalVariables].currentUser = [[User alloc] initWithAttributes:dic];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"currentUserDic"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            _txtUserName.text = @"";
            _txtPassword.text = @"";
            
            [self.delegate didLoginSuccess];
        }
        else{
            [GlobalVariables handleErrorByString:@"登入失败!请确认用户名密码!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GlobalVariables handleErrorByString:@"登入失败!请确认网络连接!"];
        NSLog(@"Error: %@", error);
    }];

}

- (IBAction)siginClicked:(id)sender {
}



@end
