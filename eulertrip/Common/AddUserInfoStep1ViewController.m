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
    
    NSString *sexStr;
}
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirth;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *btnMan;
@property (weak, nonatomic) IBOutlet UIButton *btnWoman;
@property (weak, nonatomic) IBOutlet UIButton *btnMM;
@property (weak, nonatomic) IBOutlet UIButton *btnWW;
@property (weak, nonatomic) IBOutlet UIButton *btnNormal;


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
    
    _btnMan.alpha = 0;
    _btnWoman.alpha = 0;
    _btnMM.alpha = 0;
    _btnWW.alpha = 0;
    _btnNormal.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [self startAnimation];
}

-(void)startAnimation{
    
    [GlobalVariables scaleView:_btnMan duration:0.2 finish:^(BOOL finished) {
        [GlobalVariables scaleView:_btnWoman duration:0.2 finish:^(BOOL finished) {
            [GlobalVariables scaleView:_btnMM duration:.2 finish:^(BOOL finished) {
                [GlobalVariables scaleView:_btnWW duration:.2 finish:^(BOOL finished) {
                    [GlobalVariables scaleView:_btnNormal duration:.2];
                }];
            }];
        }];
    }];
}

- (IBAction)sexSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    _btnMan.selected = NO;
    _btnWoman.selected = NO;
    _btnMM.selected = NO;
    _btnWW.selected = NO;
    _btnNormal.selected = NO;
    
    button.selected = YES;
    
    switch (button.tag) {
        case 11:
            sexStr = @"1";
            break;
        case 12:
            sexStr = @"0";
            break;
        case 13:
            sexStr = @"11";
            break;
        case 14:
            sexStr = @"00";
            break;
        case 15:
            sexStr = @"10";
            break;
        default:
            break;
    }
}



- (IBAction)nextClicked:(id)sender {
    //-----验证输入------
    if (!_txtName.text || [_txtName.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:StringLoginAlertName] animated:YES completion:nil];
        return;
    }
    if (!_txtBirth.text || [_txtBirth.text isEqualToString:@""]) {
        [self presentViewController:[GlobalVariables addAlertBy:StringLoginAlertBirth] animated:YES completion:nil];
        return;
    }
    if(!sexStr || [sexStr isEqualToString:@""]){
        [self presentViewController:[GlobalVariables addAlertBy:StringLoginAlertSex] animated:YES completion:nil];
        return;
    }
    
    //-----调用接口-------
    [ApplicationDelegate showLoadingHUD:StringLoadingMessage view:self.view];
    
    NSString *dateString = [[_txtBirth.text componentsSeparatedByString:@":"] lastObject];
    
    NSDictionary *parameters = @{MD_User_NickName:_txtName.text,MD_User_Birth:dateString,MD_User_Sex:sexStr,MD_User_Id:[IceOAuthCredential shareCredential].userId};
    
    [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:API_BaseInfo andParameters:parameters success:^(id _Nullable responseObject) {
        
        [ApplicationDelegate HUD].hidden = YES;
        
        [self.navigationController pushViewController:[[AddUserInfoStep2ViewController alloc] init] animated:YES];
        
    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
    }];

}

- (IBAction)showDatePicker:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
