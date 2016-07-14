//
//  UserViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "UserViewController.h"
#import "GlobalVariables.h"

@interface UserViewController ()
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
