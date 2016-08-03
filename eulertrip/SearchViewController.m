//
//  SearchViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/13.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "SearchViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "SearchResultTableViewController.h"


@interface SearchViewController ()<AMapLocationManagerDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>
{
    UITapGestureRecognizer *tapGesture;
    NSArray *datasourceArray;
    
    UISearchController *searchVC;
    SearchResultTableViewController *searchResultVC;
}

@property (weak, nonatomic) IBOutlet UISearchBar *txtSearch;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datasourceArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",nil];
    
    searchResultVC = [[SearchResultTableViewController alloc] initWithNibName: @"SearchResultTableViewController" bundle: nil];
    
    searchVC = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    searchVC.searchResultsUpdater = self;
    searchVC.dimsBackgroundDuringPresentation = NO;
    searchVC.hidesNavigationBarDuringPresentation = NO;
    searchVC.delegate = self;
    
    //UI
    _txtSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtSearch.layer.borderWidth = 2;
    _txtSearch.layer.cornerRadius = 10;
    [_txtSearch setBackgroundColor:[UIColor clearColor]];
    [_txtSearch setBarTintColor:[UIColor clearColor]];

    UITextField *searchField = [_txtSearch valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
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
    
    //Location
    
    [GlobalVariables locationManager].delegate = self;
    
    //启动LocationService
    // 带逆地理（返回坐标和地址信息）。将下面代码中的YES改成NO，则不会返回地址信息。
    [[GlobalVariables locationManager] requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        //        [GlobalVariables shareGlobalVariables].userLocation = location;
        //        [GlobalVariables shareGlobalVariables].location     = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.tintColor = color_common_red;
    self.navigationController.navigationBar.hidden = YES;
    
    [super viewWillAppear:animated];
}


- (IBAction)searchClicked:(id)sender {
    if([self needLogin]){
        return;
    }
     NSLog(@"not needLogin");

//    NSMutableArray *historyArray = [NSUserDefaults standardUserDefaults]objectForKey:ud_search
    //    [self performSegueWithIdentifier:@"seguePlan" sender:self];
}


#pragma mark - UISearchResultsUpdating

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"!!!!:%@",searchText);
}

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchText = searchController.searchBar.text;
    
    NSLog(@"!:%@",searchText);
//    [_resultTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datasourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    TLCity *city =  [self.data objectAtIndex:indexPath.row];
    [cell.textLabel setText:[datasourceArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    TLCity *city = [self.data objectAtIndex:indexPath.row];
//    if (_searchResultDelegate && [_searchResultDelegate respondsToSelector:@selector(searchResultControllerDidSelectCity:)]) {
//        [_searchResultDelegate searchResultControllerDidSelectCity:city];
//    }
}

#pragma mark - DB
-(void)startSearchPlan{
    
}


#pragma mark - keyboard
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    
//    NSLog(@"textFieldShouldReturn");
//    
//    
//    
//    return YES;
//}


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
    CGRect rect   = self.view.frame;
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

