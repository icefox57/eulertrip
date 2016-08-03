//
//  AddUserInfoStep1ViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/26.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "AddUserInfoStep1ViewController.h"
#import "AddUserInfoStep2ViewController.h"

@interface AddUserInfoStep1ViewController ()<UITextFieldDelegate>
{
    UITapGestureRecognizer *tapGesture;
    NSArray *sexImageArray;
}
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirth;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end


@implementation AddUserInfoStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnNext.layer.cornerRadius  = 25.0f;
    [_txtName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtBirth setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //runtime 修改 默认控件
    [_datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString( @"setHighlightsToday:" );
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature :
                                [UIDatePicker
                                 instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:_datePicker];
    
    
    //性别选择
    UIImage *seven = [UIImage imageNamed:@"login_btn_code"];
    UIImage *bar = [UIImage imageNamed:@"login_icon_phone"];
    UIImageView *sevenView = [[UIImageView alloc] initWithImage:seven];
    [sevenView setFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *barView = [[UIImageView alloc] initWithImage:bar];
    [barView setFrame:CGRectMake(0, 0, 20, 20)];
    
    sexImageArray = [[NSArray alloc]init];
    sexImageArray = [NSArray arrayWithObjects:sevenView,barView,barView,sevenView, nil];
    
    
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

- (IBAction)nextClicked:(id)sender {
    //-----验证输入------
    if (!_txtName.text || [_txtName.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请输入昵称!"] animated:YES completion:nil];
        return;
    }
    if (!_txtBirth.text || [_txtBirth.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:@"请选择生日!"] animated:YES completion:nil];
        return;
    }
    
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:LoadingMessage view:self.view];
    
    NSDictionary *parameters = @{@"NickName":_txtName.text,@"Birth":_txtBirth.text,@"Sex":@1,@"Id":[IceOAuthCredential shareCredential].userId};
    
    [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:@"v1/User/BaseInfo" andParameters:parameters success:^(id _Nullable responseObject) {
        
        [ApplicationDelegate HUD].hidden = YES;
        
        [self.navigationController pushViewController:[[AddUserInfoStep2ViewController alloc] init] animated:YES];
        
    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
    }];

}

- (IBAction)showDatePicker:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        _datePicker.alpha = 1;
    } completion:^(BOOL finished) {
        tapGesture.enabled = YES;
    }];
}

- (IBAction)dateSelected:(id)sender {
    NSDate *select  = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    
    _txtBirth.text = [NSString stringWithFormat:@"出生年月:%@",dateAndTime];
    
    
    [UIView animateWithDuration:1 animations:^{
        _datePicker.alpha = 0;
    } completion:^(BOOL finished) {
        tapGesture.enabled = NO;
    }];
}

#pragma mark - keyboard

- (IBAction)closeKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:1 animations:^{
        _datePicker.alpha = 0;
    } completion:^(BOOL finished) {
        tapGesture.enabled = NO;
    }];
}

-(void)keyboardWillShow
{
    tapGesture.enabled = YES;
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
