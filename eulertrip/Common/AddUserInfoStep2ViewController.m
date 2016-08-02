//
//  AddUserInfoStep2ViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/29.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "AddUserInfoStep2ViewController.h"
#import "GlobalVariables.h"
#import "AFAppDotNetAPIClient.h"
#import "TLCityPickerController.h"

@interface AddUserInfoStep2ViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,TLCityPickerDelegate>
{
    UITapGestureRecognizer *tapGesture;
    
    NSArray *bloodArray;
    
    UITextField *txtCurrent;
    TLCityPickerController *cityPickerVC;
}

@property (weak, nonatomic) IBOutlet UITextField *txtBirthLocal;
@property (weak, nonatomic) IBOutlet UITextField *txtLiveLocal;
@property (weak, nonatomic) IBOutlet UITextField *txtSchool;
@property (weak, nonatomic) IBOutlet UITextField *txtProf;
@property (weak, nonatomic) IBOutlet UITextField *txtBloodType;
@property (weak, nonatomic) IBOutlet UITextField *txtHobby;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIPickerView *bloodPicker;

@end

@implementation AddUserInfoStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //ui
    _btnNext.layer.cornerRadius  = 25.0f;
    _btnSkip.layer.borderWidth = 2.0f;
    _btnSkip.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnSkip.layer.cornerRadius = 20.0f;

    cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    //data
    bloodArray = [NSArray arrayWithObjects:@"A型",@"AB型",@"B型",@"O型", nil];
    
    //keyboard
    
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

- (IBAction)skipClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)nextClicked:(id)sender {
}

- (IBAction)showBirthLocPickClicked:(id)sender {
    txtCurrent = _txtBirthLocal;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

- (IBAction)showLiveLocPickerClicked:(id)sender {
    txtCurrent = _txtLiveLocal;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

- (IBAction)showBloodPickClicked:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        _bloodPicker.alpha = 1;
    } completion:^(BOOL finished) {
        tapGesture.enabled = YES;
    }];
}

#pragma mark - TLCityPickerDelegate
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    txtCurrent.text = city.cityName;
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//    return  20;
//}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return bloodArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [bloodArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _txtBloodType.text = [bloodArray objectAtIndex:row];
    [UIView animateWithDuration:1 animations:^{
        _bloodPicker.alpha = 0;
    } completion:^(BOOL finished) {
        tapGesture.enabled = NO;
    }];
    
}
#pragma mark - text

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 10) {
        
    }
    else{
        [self restViewY:-150];
    }
}

#pragma mark - keyboard

- (IBAction)closeKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:1 animations:^{
        _bloodPicker.alpha = 0;
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
