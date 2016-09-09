//
//  PlanlistTableViewCell.m
//  eulertrip
//
//  Created by ice.hu on 16/8/4.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "PlanlistTableViewCell.h"
#import "GlobalVariables.h"

@implementation PlanlistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _viewBg.layer.masksToBounds = YES;
    _viewBg.layer.cornerRadius = 10;
        
    _imgHead.layer.masksToBounds = YES;
    _imgHead.layer.cornerRadius = _imgHead.bounds.size.width * 0.5;
    _imgHead.layer.borderWidth = .75;
    _imgHead.layer.borderColor = color_common_red.CGColor;
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imgPic.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _imgPic.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _imgPic.layer.mask = maskLayer;
    
    float height = ([[UIScreen mainScreen]bounds].size.width / 375) * 160;
    _bgHeight.constant = height;
    _imgHeight.constant = height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
