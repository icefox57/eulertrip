//
//  SearchViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITextFieldDelegate>
{
    UITapGestureRecognizer *tapGesture;
}

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - DB
-(void)startSearchPlan{
    
}


#pragma mark - keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSLog(@"textFieldShouldReturn");
    
    
    
    return YES;
}

- (IBAction)closeKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    tapGesture.enabled = YES;
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    if ((_txtSearch.frame.origin.y+_txtSearch.frame.size.height+20)>keyboardBounds.origin.y){
        int offsetY = keyboardBounds.origin.y - (_txtSearch.frame.origin.y+_txtSearch.frame.size.height+20);
        [self restViewY:offsetY];
    }
}

-(void)keyboardWillHide:(NSNotification *)note
{
    tapGesture.enabled = NO;
    [self restViewY:0];
}

-(void)restViewY:(int)y
{
    CGRect rect = self.view.frame;
    rect.origin.y = y;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setFrame:rect];
    }];
}

//- (IBAction)closeKeyboard:(id)sender {
//    [UIView animateWithDuration:0.5 animations:^{
//        inputToolbar.alpha = 0;
//    } completion:^(BOOL finished) {
//        [inputToolbar.textView resignFirstResponder];
//    }];
//}
//
//-(void)inputButtonPressed:(NSString *)inputText
//{
//    [self didSendCommentWithText:inputText];
//}

//-(void) keyboardWillShow:(NSNotification *)note{
//    // get keyboard size and loctaion
//    CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // Need to translate the bounds to account for rotation.
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//    
//    // get a rect for the textView frame
//    CGRect containerFrame = _txtSearch.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    
//    // set views with new info
//    _txtSearch.frame = containerFrame;
//    
////    tapGesture.enabled = YES;
//    // commit animations
//    [UIView commitAnimations];
//}
//
//-(void) keyboardWillHide:(NSNotification *)note{
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // get a rect for the textView frame
//    CGRect containerFrame = _txtSearch.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
//    
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    
//    // set views with new info
//    _txtSearch.frame = containerFrame;
//    
////    tapGesture.enabled = NO;
//    // commit animations
//    [UIView commitAnimations];
//}


@end