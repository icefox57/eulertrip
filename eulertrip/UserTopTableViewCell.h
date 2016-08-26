//
//  UserTopTableViewCell.h
//  eulertrip
//
//  Created by ice.hu on 16/8/26.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@class UserTopTableViewCell;

@protocol UserTopTableViewCellDelegate
-(void)needShowActionView:(NSInteger)type;
@end

@interface UserTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUserBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserHead;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIView *viewSegement;
@property (weak, nonatomic) IBOutlet UIButton *btnPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet UIButton *btnFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;

@property (nonatomic, weak)id<UserTopTableViewCellDelegate> delegate;

@end
