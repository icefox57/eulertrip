//
//  LoginViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"


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
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPass;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _btnCode.layer.cornerRadius = 15.0f;    
    _btnLogin.layer.cornerRadius  = 25.0f;
    [_txtUserName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtUserName setValue:[UIFont systemFontOfSize:16.f] forKeyPath:@"_placeholderLabel.font"];
    [_txtPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtPassword setValue:[UIFont systemFontOfSize:16.f] forKeyPath:@"_placeholderLabel.font"];
    
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
- (IBAction)forgetPassClicked:(id)sender {
    
    [UIView animateWithDuration:1 animations:^{
        _btnForgetPass.alpha = 0;
        _btnCode.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)codeClicked:(id)sender {
    //-----验证输入------
    if (!_txtUserName.text || [_txtUserName.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入手机号!"] animated:YES completion:nil];
        return;
    }

    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"Mobile":_txtUserName.text,@"Smstype":@2,API_OAuth_deviceID:[DLUDID value]};
    
    [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:@"v1/Sms/GetSms" andParameters:parameters success:^(id _Nullable responseObject) {
        [ApplicationDelegate HUD].hidden = YES;
        
        _btnCode.enabled         = NO;
        reactiveSec              = 60;
        getCodeReactiveTimer     = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkGetCodeReactive) userInfo:nil repeats:YES];
        _txtPassword.placeholder = @"请输入密码或动态密码";
        
    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
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
    
    
    [IceOAuthCredential getUserAccessToekn:_txtUserName.text password:_txtPassword.text success:^(id _Nullable responseObject) {
        
        NSDictionary *parameters = @{@"Mobile":_txtUserName.text};
        
        [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:@"v1/User/GetUser" andParameters:parameters success:^(id _Nullable responseObject) {
            
            [ApplicationDelegate HUD].hidden = YES;
            
            if (![responseObject objectForKey:API_ReturnData]) {
                [self presentViewController:[GlobalVariables addAlertBy:@"获取用户信息失败!"] animated:YES completion:nil];
                return ;
                
            }
            
            NSArray *dataArray = (NSArray *)[responseObject objectForKey:API_ReturnData];
            
            
            if (dataArray.count <=0) {
                [self presentViewController:[GlobalVariables addAlertBy:@"获取用户信息失败!"] animated:YES completion:nil];
                return;
            }
            
            NSDictionary *dic = [dataArray lastObject];
            
            //存储用户信息    
            [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:API_ReturnData] forKey:UD_UserId];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [IceOAuthCredential shareCredential].userId = [dic objectForKey:API_ReturnData];
            
            [self.navigationController popViewControllerAnimated:YES];
           
        } failure:^(id _Nonnull errorDic) {
            [ApplicationDelegate HUD].hidden = YES;
            [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
        }];

        
        
        
    } failure:^(id  _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:@"error_description"]] animated:YES completion:nil];
    }];
}

- (IBAction)siginClicked:(id)sender {
    [self.navigationController pushViewController:[[SignupViewController alloc] init] animated:YES];
}


-(void)checkGetCodeReactive
{
    reactiveSec--;
    if (reactiveSec>0) {
        [_btnCode setTitle:[NSString stringWithFormat:@"%d秒后重发",reactiveSec] forState:UIControlStateDisabled];
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
