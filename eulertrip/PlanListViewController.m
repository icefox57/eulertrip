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

#import "FSCalendar.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface PlanListViewController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate,UITextFieldDelegate,AMapSearchDelegate>{

    NSString *BeginDateStr,*EndDateStr,*Departed,*Arrived;
    
    NSArray *datasourceArray;
    
    BOOL isSeachAmap;
    
    
    //calendar
    NSDate *startDate,*endDate;
    NSDictionary *dataDic;
    
    //text
    AMapSearchAPI *searchApi;
    NSArray *searchDataArray;
    NSMutableArray *searchList;
}

//view title
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UILabel *lbBeginDate;
@property (weak, nonatomic) IBOutlet UILabel *lbEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDeparted;
@property (weak, nonatomic) IBOutlet UILabel *lbArrived;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowSearch;

//table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//view search
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIView *viewSearchContent;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchBeginDate;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchDeparted;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchArrived;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchDeparted2;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchArrived2;
//view text search
@property (weak, nonatomic) IBOutlet UIView *viewTextSearch;
@property (weak, nonatomic) IBOutlet UIView *viewTextSContent;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarViewTopConstraint;

@end

@implementation PlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ui
    _viewSearchContent.layer.shadowOffset = CGSizeMake(1, 3);
    _viewSearchContent.layer.shadowRadius = 1;
    _viewSearchContent.layer.shadowOpacity = 0.2f;
    _viewSearchContent.layer.borderWidth = 0.5f;
    _viewSearchContent.layer.borderColor = color_vlight_gray.CGColor;
    
    _viewTextSContent.layer.shadowOffset = CGSizeMake(1, 3);
    _viewTextSContent.layer.shadowRadius = 1;
    _viewTextSContent.layer.shadowOpacity = 0.2f;
    _viewTextSContent.layer.borderWidth = 0.5f;
    _viewTextSContent.layer.borderColor = color_vlight_gray.CGColor;
    
    _calendar.layer.shadowOffset = CGSizeMake(1, 3);
    _calendar.layer.shadowRadius = 1;
    _calendar.layer.shadowOpacity = 0.2f;
    _calendar.layer.borderWidth = 0.5f;
    _calendar.layer.borderColor = color_vlight_gray.CGColor;
    
    _calendar.headerHeight = 30;
    [_calendar.appearance setHeaderTitleFont:[UIFont systemFontOfSize:14]];
    _calendar.appearance.headerTitleColor = color_common_red;
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_CalendarDataDic]) {
        dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:UD_CalendarDataDic];
    }
    
    //DB
    BeginDateStr = @"";
    EndDateStr = @"";
    Departed = @"";
    Arrived = @"";
    searchList = [NSMutableArray array];
    
    //keyborad
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [_txtSearch addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [_resultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    //初始化检索对象
    searchApi = [[AMapSearchAPI alloc] init];
    searchApi.delegate = self;
    
    //$$$
//    [self getPlanData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}

//$$$ no back button here
- (IBAction)backClicked:(id)sender {
}

//$$$ share?
- (IBAction)moreClicked:(id)sender {
}


- (IBAction)showSearchViewClicked:(id)sender {

    //收起
    if (_buttonShowSearch.isSelected) {
        if (_viewSearch.alpha>0) {
            [self hideTextSearchView];
        }
        if (_viewCalendar.alpha>0) {
            [self hideCalendarView];
        }
        
        [UIView animateWithDuration:1 animations:^{
            _viewSearch.alpha = 0;
            _searchViewTopConstraint.constant = 10;
            [_viewSearch layoutIfNeeded];
            [_tableView layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    //放下
    else{
        [UIView animateWithDuration:1 animations:^{
            _viewSearch.alpha = 1;
            _searchViewTopConstraint.constant = 110;
            [_viewSearch layoutIfNeeded];
            [_tableView layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    
    _buttonShowSearch.selected = !_buttonShowSearch.selected;
}

- (IBAction)showDateClicked:(id)sender {
    if (_viewCalendar.alpha > 0) {
        [self hideCalendarView];
    }
    else{
        [self showCalendarView];
    }
}

- (IBAction)showDepartedSearchClicked:(id)sender {
    isSeachAmap = YES;
    
    if (_viewTextSearch.alpha > 0) {
        [self hideTextSearchView];
    }
    else{
        [self showTextSearchView];
    }
}

- (IBAction)showArrivedSearchClicked:(id)sender {
    isSeachAmap = NO;

    if (_viewTextSearch.alpha > 0) {
        [self hideTextSearchView];
    }
    else{
        [self showTextSearchView];
    }
}

#pragma mark - Animation

-(void)showTextSearchView{
    if (_viewCalendar.alpha>0) {
        [self hideCalendarView];
    }
    
    _txtSearch.text = @"";
    
    [UIView animateWithDuration:1 animations:^{
        _viewTextSearch.alpha = 1;
        _textViewTopConstraint.constant = 0;
        _tableViewTopConstraint.constant = 40;
        [_viewTextSearch layoutIfNeeded];
        [_tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)hideTextSearchView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:1 animations:^{
        _viewTextSearch.alpha = 0;
        _textViewTopConstraint.constant = -_viewTextSearch.frame.size.height;
        _tableViewTopConstraint.constant = 0;
        [_viewTextSearch layoutIfNeeded];
        [_tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)showCalendarView{
    if (_viewTextSearch.alpha>0) {
        [self hideTextSearchView];
    }
    
    [UIView animateWithDuration:1 animations:^{
        _viewCalendar.alpha = 1;
        _calendarViewTopConstraint.constant = 0;
        _tableViewTopConstraint.constant = _viewCalendar.frame.size.height;
        [_viewCalendar layoutIfNeeded];
        [_tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)hideCalendarView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:1 animations:^{
        _viewCalendar.alpha = 0;
        _calendarViewTopConstraint.constant = -_viewCalendar.frame.size.height;
        _tableViewTopConstraint.constant = 0;
        [_viewCalendar layoutIfNeeded];
        [_tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
        //$$$!!!执行搜索
//        [self getPlanData];
    }];
}

#pragma mark - Calendar

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    if (!startDate) {
        startDate = date;
        [calendar reloadData];
        [calendar setCurrentPage:date];
        
        //ui
        BeginDateStr = [GlobalVariables stringFromDate:startDate];
        _lbBeginDate.text = [GlobalVariables stringFromDate:startDate format:@"MM/dd"];
        _lbSearchBeginDate.text = [GlobalVariables stringFromDate:startDate];
    }
    else{
        endDate = date;
        NSInteger days = [GlobalVariables getDaysFrom:startDate To:endDate];
        if (days == 0) {
            return;
        }
        
        [self addDayToSelectDateArray:date days:days];
        
        //ui
        EndDateStr = [GlobalVariables stringFromDate:endDate];
        _lbEndDate.text = [GlobalVariables stringFromDate:endDate format:@"MM/dd"];
        _lbSearchEndDate.text = [GlobalVariables stringFromDate:endDate];
    }
}


-(void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date{
    
    
    if (![calendar isDate:date equalToDate:endDate toCalendarUnit:FSCalendarUnitDay]) {
        for (NSDate *date in _calendar.selectedDates) {
            [_calendar deselectDate:date];
        }
        
        startDate = nil;
        endDate = nil;
        [calendar reloadData];
        [calendar setCurrentPage:[NSDate date] animated:YES];
        
        //ui
        BeginDateStr = @"";
        _lbBeginDate.text = @"出发日期";
        _lbSearchBeginDate.text = @"出发日期";
        EndDateStr = @"";
        _lbEndDate.text = @"返程日期";
        _lbSearchEndDate.text = @"返程日期";
    }
    else{
        endDate = [calendar dateByAddingDays:-1 toDate:endDate];
        
        //ui
        EndDateStr = [GlobalVariables stringFromDate:endDate];
        _lbEndDate.text = [GlobalVariables stringFromDate:endDate format:@"MM-dd"];
        _lbSearchEndDate.text = [GlobalVariables stringFromDate:endDate];
    }
}

-(NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(nonnull NSDate *)date{
    return dataDic[[GlobalVariables stringFromDate:date format:@"yyyy-MM-dd"]];
}


- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    if (startDate) {
        return startDate;
    }
    return [NSDate date];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    if (startDate) {
        return [calendar dateByAddingDays:4 toDate:startDate];
    }
    return [calendar dateByAddingMonths:6 toDate:[NSDate date]];
}


-(void)addDayToSelectDateArray:(NSDate *)date days:(NSInteger)days{
    if (_calendar.selectedDates && [_calendar.selectedDates count]>0) {
        for (NSDate *date in _calendar.selectedDates) {
            [_calendar deselectDate:date];
        }
    }
    
    for (int x=0; x<=days; x++) {
        [_calendar selectDate:[_calendar dateByAddingDays:x toDate:startDate]];
    }
}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
        return 39;
    }
    else{
        return 170;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 99) {
        if ([_txtSearch isFirstResponder] && ![_txtSearch.text isEqualToString:@""]){
            return searchList.count;
        }
        return  0;
    }
    else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor clearColor];
        AMapTip *p = [searchList objectAtIndex:indexPath.row];
        [cell.textLabel setText:p.name];

        return cell;
    }
    else{
        static NSString *CellIdentifier = @"CellPlanList";
        PlanlistTableViewCell *cell = (PlanlistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanlistTableViewCell" owner:self options:nil] lastObject];
        }
        
        ModelTrip *currentTrip = [datasourceArray objectAtIndex:indexPath.row];
        
        cell.lbFrom.text = currentTrip.departed;
        cell.lbTo.text = currentTrip.arrived;
        cell.lbStarCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)currentTrip.favorites];
        cell.lbDays.text = [NSString stringWithFormat:@"%ld Days",(long)[GlobalVariables getDaysFrom:currentTrip.beginDate To:currentTrip.endDate]];
        
        [cell.imgPic sd_setImageWithURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/mw690/8355dac5gw1f6ip5g07u5j20m80xbjyb.jpg"]
                          placeholderImage:[UIImage imageNamed:@"login_bg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 }];
    //    [cell.imgPic setImage:[UIImage imageNamed:@"search_bg1"]];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
        AMapTip *p = [searchList objectAtIndex:indexPath.row];        
        _txtSearch.text = p.district;
        
        [_txtSearch resignFirstResponder];
        [self hideSuggestTableView];
    }
    else{
        
    }
}



#pragma mark - Utility

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"上海";
    tips.cityLimit = NO;
    
    [searchApi AMapInputTipsSearch:tips];
}


-(void)showSuggestTableView{
    [UIView animateWithDuration:1 animations:^{
        _resultTableView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

-(void)hideSuggestTableView{
    [UIView animateWithDuration:1 animations:^{
        _resultTableView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - SearchAPI
//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0){
        [self hideSuggestTableView];
        return;
    }
    
    [self showSuggestTableView];
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    if (searchList) {
        [searchList removeAllObjects];
    }
    
    for (AMapTip *p in response.tips) {
        [searchList addObject:p];
    }
    
    [_resultTableView reloadData];
}


#pragma mark - keyboard

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(isSeachAmap){
        Departed = _txtSearch.text;
        _lbDeparted.text = _txtSearch.text;
        _lbSearchDeparted.text =  _txtSearch.text;
        _lbSearchDeparted2.text = _txtSearch.text;
    }
    else{
        Arrived = _txtSearch.text;
        _lbArrived.text = _txtSearch.text;
        _lbSearchArrived.text = _txtSearch.text;
        _lbSearchArrived2.text = _txtSearch.text;
    }
    
    //$$$执行搜索
    //[self getPlanData];
    
    [UIView animateWithDuration:1 animations:^{
        _resultTableView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    //高德搜索
    if (isSeachAmap) {
        [self searchTipsWithKey:[textField text]];
    }
    //服务器搜索
    else{
        //$$$
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}


- (IBAction)closeKeyboard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)keyboardWillShow:(NSNotification *)note
{

}

-(void)keyboardWillHide:(NSNotification *)note
{
    [self hideTextSearchView];
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
        
        //$$$
        //解析行程数组
        datasourceArray = [NSArray arrayWithArray:[ModelTrip parserResponseToObject:dataArray]];
        //读取行程搜索参数
        _lbBeginDate.text = @"";_lbSearchBeginDate.text = @"";
        _lbEndDate.text = @"";_lbSearchEndDate.text = @"";
        _lbArrived.text = @"";_lbSearchArrived.text = @""; _lbSearchArrived2.text = @"";
        _lbDeparted.text = @"";_lbSearchDeparted.text = @""; _lbSearchDeparted2.text = @"";
        
        
        [_tableView reloadData];

    } failure:^(id _Nonnull errorDic) {
        [ApplicationDelegate HUD].hidden = YES;
        [self presentViewController:[GlobalVariables addAlertBy:[errorDic objectForKey:API_ErrorMessage]] animated:YES completion:nil];
    }];
}


@end
