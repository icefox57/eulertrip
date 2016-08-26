//
//  UserViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "UserViewController.h"
#import "GlobalVariables.h"
#import "UserTopTableViewCell.h"

@interface UserViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UserTopTableViewCellDelegate>{
    NSInteger actionType;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewMain;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden   = NO;
    self.tabBarController.tabBar.tintColor = color_common_red;
    [super viewWillAppear:animated];
    
    
//    if(![self needLogin]){
//        //$$$ 读取用户信息
//    }
//    else{
//        NSLog(@"needLogin");
//    }
}

#pragma mark - Cell Delegate
-(void)needShowActionView:(NSInteger)type{
    actionType = type;
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"选择图像"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (type == 1) {
        UIAlertAction* actCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* actTakePhoto = [UIAlertAction actionWithTitle:@"更换封面 - 拍照" style:UIAlertActionStyleDefault
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
        
        UIAlertAction* actSelectPhoto = [UIAlertAction actionWithTitle:@"更换封面 - 从相册选择" style:UIAlertActionStyleDefault
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
    }
    else{
        UIAlertAction* actCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* actTakePhoto = [UIAlertAction actionWithTitle:@"更换头像 - 拍照" style:UIAlertActionStyleDefault
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
        
        UIAlertAction* actSelectPhoto = [UIAlertAction actionWithTitle:@"更换头像 - 从相册选择" style:UIAlertActionStyleDefault
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
    }
    
    [self presentViewController:sheet animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
        return 39;
    }
    else{
        return 335;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 99) {
        return  0;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
        return nil;
    }
    else{
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"CellUserTop";
            UserTopTableViewCell *cell = (UserTopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"UserTopTableViewCell" owner:self options:nil] lastObject];
            }
            
            cell.delegate = self;
            
            
            return cell;

        }
        
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
       
    }
    else{
        
    }
}




#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    UserTopTableViewCell *cell = (UserTopTableViewCell *)[_tableViewMain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (actionType == 1) {
        cell.imgUserBg.image = image;
    }
    else{
        cell.imgUserHead.image = image;
    }
    
    //$$$ 上传图片到服务器
}

@end
