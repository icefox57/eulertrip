//
//  SearchViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "SearchViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface SearchViewController ()<AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapSearchDelegate>
{
    UITapGestureRecognizer *tapGesture;
    NSArray *datasourceArray;
    NSMutableArray *searchList;
    
    UISearchController *searchVC;
    AMapSearchAPI *searchApi;
}

@property (weak, nonatomic) IBOutlet UIView *viewSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datasourceArray = [NSArray array];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_SearchHistroyArray]) {
        datasourceArray = [[NSUserDefaults standardUserDefaults]objectForKey:UD_SearchHistroyArray];
        [_resultTableView reloadData];
    }

    searchList = [NSMutableArray array];
    
    //UI
    _viewSearchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    _viewSearchBar.layer.borderWidth = 1;
    _viewSearchBar.layer.cornerRadius = 10;
    _resultTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    _resultTableView.layer.borderWidth = 1;
    _resultTableView.layer.cornerRadius = 10;

    [_txtSearch setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
//    UITextField *searchField = [_txtSearch valueForKey:@"_searchField"];
//    searchField.textColor = [UIColor whiteColor];
//    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [_resultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    //keyborad
    
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
    
    [_txtSearch addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //Location
    
    [GlobalVariables locationManager].delegate = self;
    
    //启动LocationService
    // 带逆地理（返回坐标和地址信息）。将下面代码中的YES改成NO，则不会返回地址信息。
    [[GlobalVariables locationManager] requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        [GlobalVariables shareGlobalVariables].userLocation = location;
        [GlobalVariables shareGlobalVariables].location     = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
        
        if (regeocode)  {
            NSLog(@"reGeocode:%@", regeocode);
            
            [GlobalVariables shareGlobalVariables].userCity = regeocode.city;
            [GlobalVariables shareGlobalVariables].userProvince = regeocode.province;
        }
    }];
    
    
    //搜索提示
    
    //初始化检索对象
    searchApi = [[AMapSearchAPI alloc] init];
    searchApi.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [_txtSearch resignFirstResponder];
    self.tabBarController.tabBar.hidden   = NO;
    self.tabBarController.tabBar.tintColor = color_common_red;
    self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}


- (IBAction)searchClicked:(id)sender {
    if([self needLogin]){
        return;
    }
     NSLog(@"not needLogin");

    //搜索记录到本地
    NSMutableArray *historyArray;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_SearchHistroyArray]) {
        historyArray = [[[NSUserDefaults standardUserDefaults]objectForKey:UD_SearchHistroyArray]mutableCopy];
    }
    else{
        historyArray = [[NSMutableArray alloc]init];
    }
    [historyArray addObject:_txtSearch.text];
    [[NSUserDefaults standardUserDefaults]setObject:historyArray forKey:UD_SearchHistroyArray];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //    [self performSegueWithIdentifier:@"seguePlan" sender:self];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_txtSearch isFirstResponder] && ![_txtSearch.text isEqualToString:@""]){
        return searchList.count;
    }
    else if (datasourceArray) {
        return datasourceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    TLCity *city =  [self.data objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    if ([_txtSearch isFirstResponder] && ![_txtSearch.text isEqualToString:@""]){
        [cell.textLabel setText:[searchList objectAtIndex:indexPath.row]];
    }
    else{
        [cell.textLabel setText:[datasourceArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"textLabel:%@",[tableView cellForRowAtIndexPath:indexPath].textLabel.text);
    _txtSearch.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
//    if ([_txtSearch isFirstResponder] && ![_txtSearch.text isEqualToString:@""]){
//        _txtSearch.text = [searchList objectAtIndex:indexPath.row];
//    }
//    else{
//        _txtSearch.text = [datasourceArray objectAtIndex:indexPath.row];
//    }
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_txtSearch resignFirstResponder];
    [self hideSuggestTableView];
//    TLCity *city = [self.data objectAtIndex:indexPath.row];
//    if (_searchResultDelegate && [_searchResultDelegate respondsToSelector:@selector(searchResultControllerDidSelectCity:)]) {
//        [_searchResultDelegate searchResultControllerDidSelectCity:city];
//    }
}

#pragma mark - DB
-(void)startSearchPlan{
    
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
        tapGesture.enabled = NO;
    }];
}

-(void)hideSuggestTableView{
    [UIView animateWithDuration:1 animations:^{
        _resultTableView.alpha = 0;
    } completion:^(BOOL finished) {
        tapGesture.enabled = YES;
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
        [searchList addObject:p.name];
    }
    
    [_resultTableView reloadData];
}


#pragma mark - keyboard
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //加载甲方数据
    
    /*
    if (datasourceArray && [datasourceArray count]>0) {
        [_resultTableView reloadData];
        [UIView animateWithDuration:1 animations:^{
            _resultTableView.alpha = 1;
        } completion:^(BOOL finished) {
            tapGesture.enabled = NO;
        }];
    }
     */
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:1 animations:^{
        _resultTableView.alpha = 0;
    } completion:^(BOOL finished) {
        tapGesture.enabled = YES;
    }];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
//    NSLog(@"textField text : %@", [textField text]);
//    
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", [textField text]];
//    if (searchList) {
//        [searchList removeAllObjects];
//    }
//    //过滤数据
//    searchList= [NSMutableArray arrayWithArray:[datasourceArray filteredArrayUsingPredicate:preicate]];
//    //刷新表格
//    [_resultTableView reloadData];
    
    
    [self searchTipsWithKey:[textField text]];
}

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
    
    [self restViewY:-250];
    //自动计算高度
//    CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    
//    if ((_viewSearchBar.frame.origin.y+_viewSearchBar.frame.size.height+20)>keyboardBounds.origin.y){
//        int offsetY = keyboardBounds.origin.y - (_viewSearchBar.frame.origin.y+_viewSearchBar.frame.size.height+20);
//        [self restViewY:offsetY];
//    }
}

-(void)keyboardWillHide:(NSNotification *)note
{
    tapGesture.enabled = NO;
    [self restViewY:0];
    
    if (![_txtSearch.text isEqualToString:@""]) {
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", _txtSearch.text];
        if (searchList) {
            [searchList removeAllObjects];
        }
        //过滤数据
        searchList= [NSMutableArray arrayWithArray:[datasourceArray filteredArrayUsingPredicate:preicate]];
    }
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

