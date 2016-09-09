//
//  PlanlistTableViewCell.h
//  eulertrip
//
//  Created by ice.hu on 16/8/4.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanlistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lbStarCount;
@property (weak, nonatomic) IBOutlet UILabel *lbDays;
@property (weak, nonatomic) IBOutlet UILabel *lbFrom;
@property (weak, nonatomic) IBOutlet UILabel *lbTo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@end
