//
//  CalendarViewController.h
//  eulertrip
//
//  Created by ice.hu on 16/7/14.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarViewController;

@protocol CalendarViewControllerDelegate
-(void)didSelectedDate;
@end

@interface CalendarViewController : UIViewController
@property (nonatomic, weak)id<CalendarViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *startDate,*endDate;

@end
