//
//  PlanViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "PlanViewController.h"
#import "GlobalVariables.h"
#import "CalendarViewController.h"
#import "MapTableViewCell.h"

@interface PlanViewController ()<UITableViewDelegate,UITableViewDataSource,CalendarViewControllerDelegate>
@property (weak, nonatomic  ) IBOutlet UITableView            *mainTableView;
@property (weak, nonatomic  ) IBOutlet UIView                 *topView;
@property (strong, nonatomic) CalendarViewController *calendarVC;
@property (weak, nonatomic  ) IBOutlet UILabel                *lbBudget;

@end

@implementation PlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    
    [super viewWillAppear:animated];
}

- (IBAction)goFromClicked:(id)sender {
    
}

- (IBAction)startTimeClicked:(id)sender {
    
    self.calendarVC = [[CalendarViewController alloc] initWithNibName: @"CalendarViewController" bundle: nil];
    
    self.calendarVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.calendarVC.view.frame), CGRectGetHeight(self.calendarVC.view.frame));
    self.calendarVC.delegate   = self;
    [self.view addSubview:self.calendarVC.view];
    
    
}

#pragma mark - Calendar
-(void)didSelectedDate{
    
    [self.calendarVC.view removeFromSuperview];
    
    _lbBudget.text = [GlobalVariables stringFromDate:self.calendarVC.startDate format:@"yyyy-MM-dd"];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"mapCell";
    MapTableViewCell *cell = (MapTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MapTableViewCell" owner:self options:nil] lastObject];
    }

    
    return cell;
}

@end
