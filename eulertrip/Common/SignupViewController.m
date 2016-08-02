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
#import "AddUserInfoStep1ViewController.h"

@interface SignupViewController ()<UITextFieldDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *btnArg;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _buttonNext.layer.cornerRadius  = 25.0f;
    _btnGetCode.layer.cornerRadius = 15.0f; 
    
    [_txtPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtPhone setValue:[UIFont systemFontOfSize:16.f] forKeyPath:@"_placeholderLabel.font"];
    [_txtCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtCode setValue:[UIFont systemFontOfSize:16.f] forKeyPath:@"_placeholderLabel.font"];
    [_txtPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtPassword setValue:[UIFont systemFontOfSize:16.f] forKeyPath:@"_placeholderLabel.font"];
    [_txtCfPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtCfPassword setValue:[UIFont systemFontOfSize:16.f] forKeyPath:@"_placeholderLabel.font"];
    
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

- (IBAction)argCheckClicked:(id)sender {
    _btnArg.selected = !_btnArg.selected;
}

- (IBAction)argShowClicked:(id)sender {
    //$$$$$$$$$$$$
}

- (IBAction)getCodeClicked:(id)sender {
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"Mobile":_txtPhone.text,@"Smstype":@1,API_OAuth_deviceID:[DLUDID value]};
    
    [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:@"v1/Sms/GetSms" andParameters:parameters success:^(id _Nullable responseObject) {
        [ApplicationDelegate HUD].hidden = YES;
        
        _btnGetCode.enabled         = NO;
        reactiveSec              = 60;
        getCodeReactiveTimer     = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkGetCodeReactive) userInfo:nil repeats:YES];
        
    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
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
    if (_btnArg.state == UIControlStateSelected) {
        [self presentViewController:[GlobalVariables addAlertBy:@"您尚未同意协议!"] animated:YES completion:nil];
        return;
    }
    
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"Code":_txtCode.text,@"Password":_txtPassword.text,@"Mobile":_txtPhone.text,@"Smstype":@1,API_OAuth_deviceID:[DLUDID value]};
    
    [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:@"v1/User/Register" andParameters:parameters success:^(id _Nullable responseObject) {
        
        //存储用户信息
        if ([responseObject objectForKey:API_ReturnData]) {
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:API_ReturnData] forKey:UD_UserId];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
        //重新获取新token
        NSLog(@"重新获取新token~~~~");
        [IceOAuthCredential getUserAccessToekn:_txtPhone.text password:_txtPassword.text success:^(id _Nullable responseObject) {
            [ApplicationDelegate HUD].hidden = YES;
            
            [self.navigationController pushViewController:[[AddUserInfoStep1ViewController alloc] init] animated:YES];
            
        } failure:^(id  _Nonnull errorDic) {
            [ApplicationDelegate HUD].hidden = YES;
            [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:@"error_description"]] animated:YES completion:nil];
        }];
        
    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
    }];
}

-(void)checkGetCodeReactive
{
    //-----验证输入------
    if (!_txtPhone.text || [_txtPhone.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入手机号!"] animated:YES completion:nil];
        return;
    }
    
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
        [_txtCode becomeFirstResponder];
    }
    else if (textField.tag == 20){
        [_txtPassword becomeFirstResponder];
    }
    else if (textField.tag == 30){
        [_txtCfPassword becomeFirstResponder];
    }
    else{
        [self nextClicked:nil];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 10) {
    }
    else if (textField.tag == 20){
    }
    else if (textField.tag == 30){
        [self restViewY:-50];
    }
    else{
        [self restViewY:-150];
    }
}

#pragma mark - keyboard

- (IBAction)closeKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)keyboardWillShow
{
    tapGesture.enabled = YES;
    
    if ([_txtPassword isFirstResponder]) {
        [self restViewY:-50];
    }
    else if ([_txtCfPassword isFirstResponder]){
        [self restViewY:-150];
    }
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
