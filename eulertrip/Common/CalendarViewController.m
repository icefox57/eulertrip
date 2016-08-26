//
//  CalendarViewController.m
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"
#import "GlobalVariables.h"

@interface CalendarViewController () <FSCalendarDataSource, FSCalendarDelegate>
{
    NSDate *startDate,*endDate;
    NSDictionary *dataDic;
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end

@implementation CalendarViewController
@synthesize startDate,endDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.calendar.appearance.headerDateFormat = @"yyyy-MM";
//    self.calendar.identifier = NSCalendarIdentifierRepublicOfChina;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_CalendarDataDic]) {
        dataDic = [[NSUserDefaults standardUserDefaults]objectForKey:UD_CalendarDataDic];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectedClicked:(id)sender {
    [self.delegate didSelectedDate];
}


- (IBAction)previousClicked:(id)sender
{
//    NSDate *currentMonth = self.calendar.currentPage;
//    
//    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
}

- (IBAction)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    
    
}

#pragma mark - Calendar

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    if (!startDate) {
        startDate = date;
        [calendar reloadData];
        [calendar setCurrentPage:date];
    }
    else{
        endDate = date;
        NSInteger days = [GlobalVariables getDaysFrom:startDate To:endDate];
        if (days == 0) {
            return;
        }
        
        [self addDayToSelectDateArray:date days:days];
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
    }
    else{
        endDate = [calendar dateByAddingDays:-1 toDate:endDate];
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
@end
