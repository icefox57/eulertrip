//
//  LoginViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalVariables.h"
#import "MD5Util.h"
#import "SignupViewController.h"
#import "AFAppDotNetAPIClient.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITapGestureRecognizer *tapGesture;
    NSTimer *getCodeReactiveTimer;
    int reactiveSec;
}
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView      *viewLogin;
@property (weak, nonatomic) IBOutlet UIButton    *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton    *btnCode;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewLogin.layer.cornerRadius = 10.0f;
    _btnLogin.layer.cornerRadius  = 30.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden                   = YES;
    self.navigationController.navigationBar.hidden        = YES;
//    self.navigationController.navigationBar.topItem.title = LoginTitleString;
    [super viewWillAppear:animated];
}

- (IBAction)returnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)codeClicked:(id)sender {
    
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"Mobile":_txtUserName.text,@"Smstype":@2,API_OAuth_deviceID:[DLUDID value]};
    
    NSLog(@"param:%@",parameters);
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults]objectForKey:UD_TempAccessToken]] forHTTPHeaderField:@"Authorization"];
    [[AFAppDotNetAPIClient sharedClient] POST:@"v1/Sms/GetSms" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@ , P:%@", responseObject,parameters);
        
        [ApplicationDelegate HUD].hidden = YES;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"Code"] integerValue] == 1000) {
            _btnCode.enabled         = NO;
            reactiveSec              = 60;
            getCodeReactiveTimer     = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkGetCodeReactive) userInfo:nil repeats:YES];
            _txtPassword.placeholder = @"请输入密码或动态密码";
        }
        else{
            [self presentViewController:[GlobalVariables addAlertBy:@"动态密码发送失败"] animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ApplicationDelegate HUD].hidden = YES;
        
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"error:%@ , body:%@,head:%@",errorStr,task.currentRequest.HTTPBody,task.currentRequest.allHTTPHeaderFields);
        [self presentViewController:[GlobalVariables addAlertBy:errorStr] animated:YES completion:nil];
    }];
}

- (IBAction)loginClicked:(id)sender {
    
    //-----验证输入------
    if (!_txtUserName.text || [_txtUserName.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入手机号!"] animated:YES completion:nil];
        return;
    }
    
    if (!_txtPassword.text || [_txtPassword.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入密码!"] animated:YES completion:nil];
        return;
    }
    
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"grant_type":@"password",
                                 @"username":_txtUserName.text,
                                 @"password":[MD5Util md5:_txtPassword.text],
                                 API_OAuth_deviceID:[DLUDID value]};
    
    NSLog(@"param:%@",parameters);
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [[AFAppDotNetAPIClient sharedClient] POST:@"OAuth/Token" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@ , P:%@", responseObject,parameters);
        
        
        [ApplicationDelegate HUD].hidden = YES;
        
//        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"Code"] integerValue] == 1000) {
            //            NSDictionary *dic = [(NSArray *)responseObject firstObject];
            //            [GlobalVariables shareGlobalVariables].currentUser = [[User alloc] initWithAttributes:dic];
            //            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //            [self.delegate didLoginSuccess];
            
            _txtUserName.text = @"";
            _txtPassword.text = @"";
            
            //更新新token
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:API_OAuth_accesstoken] forKey:UD_UserAccessToken];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else{
//            [self presentViewController:[GlobalVariables addAlertBy:@"登入失败!请确认用户名密码!"] animated:YES completion:nil];
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ApplicationDelegate HUD].hidden = YES;
        
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"error:%@ , body:%@,head:%@",errorStr,task.currentRequest.HTTPBody,task.currentRequest.allHTTPHeaderFields);
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
    }];
    
}

- (IBAction)siginClicked:(id)sender {
    [self.navigationController pushViewController:[[SignupViewController alloc] init] animated:YES];
}


-(void)checkGetCodeReactive
{
    reactiveSec--;
    if (reactiveSec>0) {
        [_btnCode setTitle:[NSString stringWithFormat:@"已发送(%d)",reactiveSec] forState:UIControlStateDisabled];
    }
    else{
        _btnCode.enabled = YES;
        [getCodeReactiveTimer invalidate];
        getCodeReactiveTimer = nil;
    }
}

#pragma mark - text view
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 10) {
        [_txtPassword becomeFirstResponder];
    }
    else{
        [self loginClicked:nil];
    }
    return YES;
}

#pragma mark - keyboard

- (IBAction)closeKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)keyboardWillShow
{
    tapGesture.enabled = YES;
    [self restViewY:-50];
}

-(void)keyboardWillHide
{
    tapGesture.enabled = NO;
    [self restViewY:0];
}

-(void)restViewY:(int)y
{
    CGRect rect   = self.view.frame;
    rect.origin.y = y;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setFrame:rect];
    }];
}
@end
