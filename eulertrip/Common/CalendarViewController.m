//
//  CalendarViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"

@interface CalendarViewController () <FSCalendarDataSource, FSCalendarDelegate>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.calendar.appearance.headerDateFormat = @"yyyy-MM";
//    self.calendar.identifier = NSCalendarIdentifierRepublicOfChina;
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
- (IBAction)selectedClicked:(id)sender {
    [self.delegate didSelectedDate];
}


- (IBAction)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (IBAction)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    self.selectedDate = date;
}

@end
