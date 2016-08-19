//
//  PlanListViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "PlanListViewController.h"
#import "PlanlistTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ModelTrip.h"

@interface PlanListViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSString *BeginDateStr,*EndDateStr,*Departed,*Arrived;
    
    NSArray *datasourceArray;
}

@property (weak, nonatomic) IBOutlet UILabel *lbBeginDate;
@property (weak, nonatomic) IBOutlet UILabel *lbEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDeparted;
@property (weak, nonatomic) IBOutlet UILabel *lbArrived;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BeginDateStr = @"";
    EndDateStr = @"";
    Departed = @"";
    Arrived = @"";
    
    [self getPlanData];
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

#pragma mark - tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellPlanList";
    PlanlistTableViewCell *cell = (PlanlistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanlistTableViewCell" owner:self options:nil] lastObject];
    }
    
    ModelTrip *currentTrip = [datasourceArray objectAtIndex:indexPath.row];
    
    cell.lbFrom.text = currentTrip.departed;
    cell.lbTo.text = currentTrip.arrived;
    cell.lbStarCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)currentTrip.favorites];
    cell.lbDays.text = [NSString stringWithFormat:@"%ld Days",[GlobalVariables getDaysFrom:currentTrip.beginDate To:currentTrip.endDate]];
    
    [cell.imgPic sd_setImageWithURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/mw690/8355dac5gw1f6ip5g07u5j20m80xbjyb.jpg"]
                      placeholderImage:[UIImage imageNamed:@"login_bg"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }];
//    [cell.imgPic setImage:[UIImage imageNamed:@"search_bg1"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - DB

-(void)getPlanData{
    NSDictionary *parameters = @{@"BeginDate":BeginDateStr,
                                 @"EndDate":EndDateStr,
                                 @"Departed":Departed,
                                 @"Arrived":Arrived};
    
    [[AFAppDotNetAPIClient sharedClient] performPOSTRequestToURL:API_MoreTrips andParameters:parameters success:^(id _Nullable responseObject) {
        
        [ApplicationDelegate HUD].hidden = YES;
        
        if (![responseObject objectForKey:API_ReturnData]) {
            [self presentViewController:[GlobalVariables addAlertBy:StringErrorGetMoreTrip] animated:YES completion:nil];
            return ;
            
        }
        
        NSArray *dataArray = (NSArray *)[responseObject objectForKey:API_ReturnData];
        
        if (dataArray.count <=0) {
            [self presentViewController:[GlobalVariables addAlertBy:StringErrorGetMoreTrip] animated:YES completion:nil];
            return;
        }
        
        datasourceArray = [NSArray arrayWithArray:[ModelTrip parserResponseToObject:dataArray]];

    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
    }];
}


@end
