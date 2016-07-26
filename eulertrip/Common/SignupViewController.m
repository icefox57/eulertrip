//
//  SignupViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/15.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "SignupViewController.h"
#import "GlobalVariables.h"
#import "AFAppDotNetAPIClient.h"

@interface SignupViewController ()
{
    UITapGestureRecognizer *tapGesture;
    NSTimer *getCodeReactiveTimer;
    int reactiveSec;
}
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtCfPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _buttonNext.layer.cornerRadius  = 25.0f;
    
    [_txtPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
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
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeClicked:(id)sender {
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"Mobile":_txtPhone.text,@"Smstype":@1,API_OAuth_deviceID:[DLUDID value]};
    
    NSLog(@"param:%@",parameters);
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults]objectForKey:UD_TempAccessToken]] forHTTPHeaderField:@"Authorization"];
    [[AFAppDotNetAPIClient sharedClient] POST:@"v1/Sms/GetSms" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@ , P:%@", responseObject,parameters);
        
        [ApplicationDelegate HUD].hidden = YES;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"Code"] integerValue] == 1000) {
            _btnGetCode.enabled         = NO;
            reactiveSec              = 60;
            getCodeReactiveTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkGetCodeReactive) userInfo:nil repeats:YES];
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


- (IBAction)nextClicked:(id)sender {
    //-----验证输入------
    if (!_txtPhone.text || [_txtPhone.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入手机号!"] animated:YES completion:nil];
        return;
    }
    if (!_txtCode.text || [_txtCode.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入验证码!"] animated:YES completion:nil];
        return;
    }
    if (!_txtPassword.text || [_txtPassword.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入密码!"] animated:YES completion:nil];
        return;
    }
    if (!_txtCfPassword.text || [_txtCfPassword.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入确认密码!"] animated:YES completion:nil];
        return;
    }
    if (![_txtCfPassword.text isEqualToString:_txtPassword.text]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"2次密码输入不相同!"] animated:YES completion:nil];
        return;
    }
    
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"Code":_txtCode.text,@"Password":_txtPassword.text,@"Mobile":_txtPhone.text,@"Smstype":@1,API_OAuth_deviceID:[DLUDID value]};
    
    NSLog(@"param:%@",parameters);
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults]objectForKey:UD_TempAccessToken]] forHTTPHeaderField:@"Authorization"];
    [[AFAppDotNetAPIClient sharedClient] POST:@"v1/User/Register" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"JSON: %@ , P:%@", responseObject,parameters);
        
        [ApplicationDelegate HUD].hidden = YES;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"Code"] integerValue] == 1000) {
            //存储用户信息
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:API_ReturnData] forKey:UD_UserInfo];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else{
            [self presentViewController:[GlobalVariables addAlertBy:[NSString stringWithFormat:@"注册失败:%@",[responseObject objectForKey:@"Code"]]] animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ApplicationDelegate HUD].hidden = YES;
        
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString* errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"error:%@ , body:%@,head:%@",errorStr,task.currentRequest.HTTPBody,task.currentRequest.allHTTPHeaderFields);
        [self presentViewController:[GlobalVariables addAlertBy:errorStr] animated:YES completion:nil];
    }];

}

-(void)checkGetCodeReactive
{
    reactiveSec--;
    if (reactiveSec>0) {
        [_btnGetCode setTitle:[NSString stringWithFormat:@"已发送(%d)",reactiveSec] forState:UIControlStateDisabled];
    }
    else{
        _btnGetCode.enabled = YES;
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
        [self nextClicked:nil];
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
