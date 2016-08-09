//
//  UserViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "UserViewController.h"
#import "GlobalVariables.h"

#import "AddUserInfoStep1ViewController.h"

@interface UserViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgHead.layer.masksToBounds = YES;
    _imgHead.layer.cornerRadius = _imgHead.bounds.size.width * 0.5;
    _imgHead.layer.borderWidth = 5.0;
    _imgHead.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}


- (IBAction)testClicked:(id)sender {
    [self.navigationController pushViewController:[[AddUserInfoStep1ViewController alloc] init] animated:NO];
}


- (IBAction)editUserHeadClicked:(id)sender {
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"选择图像"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* actTakePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              // 判断是否支持相机
                                                              if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                  // 跳转到相机
                                                                  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                                  imagePickerController.delegate = self;
                                                                  imagePickerController.allowsEditing = YES;
                                                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                  
                                                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                                                              
                                                              }
                                                              
                                                          }];
    
    UIAlertAction* actSelectPhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             // 跳转到相册页面
                                                             UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init]; 
                                                             imagePickerController.delegate = self; 
                                                             imagePickerController.allowsEditing = YES; 
                                                             imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             
                                                             [self presentViewController:imagePickerController animated:YES completion:^{}];
                                
                                                         }];
    
    [sheet addAction:actCancel];
    [sheet addAction:actTakePhoto];
    [sheet addAction:actSelectPhoto];
    
    
    [self presentViewController:sheet animated:YES completion:nil];

}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    _imgHead.image = image;
}

@end
