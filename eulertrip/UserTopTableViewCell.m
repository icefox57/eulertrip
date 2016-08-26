//
//  UserTopTableViewCell.m
//  eulertrip
//
//  Created by ice.hu on 16/8/26.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "UserTopTableViewCell.h"

@implementation UserTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgUserHead.layer.masksToBounds = YES;
    _imgUserHead.layer.cornerRadius = _imgUserHead.bounds.size.width * 0.5;
    _imgUserHead.layer.borderWidth = .75;
    _imgUserHead.layer.borderColor = color_vlight_gray.CGColor;
    
    _viewSegement.layer.shadowOffset = CGSizeMake(0, 3);
    _viewSegement.layer.shadowRadius = 1;
    _viewSegement.layer.shadowOpacity = 0.2f;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionHeadView:)];
    [_imgUserHead addGestureRecognizer:tapGesture1];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionBgView:)];
    [_imgUserBg addGestureRecognizer:tapGesture2];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)messageClicked:(id)sender {
}

- (IBAction)planClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self segementChanged:button];
}

- (IBAction)postClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self segementChanged:button];
}

- (IBAction)friendClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self segementChanged:button];
}

- (IBAction)infoClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self segementChanged:button];
}

- (void)showActionBgView:(UITapGestureRecognizer *)gesture {
    [self.delegate needShowActionView:1];
}
- (void)showActionHeadView:(UITapGestureRecognizer *)gesture {
    [self.delegate needShowActionView:2];
}

-(void)segementChanged:(UIButton *)button{
    _btnPlan.selected = NO;
    _btnPost.selected = NO;
    _btnFriend.selected = NO;
    _btnInfo.selected = NO;
    button.selected = YES;
}

@end
