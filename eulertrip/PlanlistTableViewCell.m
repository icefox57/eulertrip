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
    
    _viewBg.layer.masksToBounds = NO;
    _viewBg.layer.cornerRadius = 10;
    _viewBg.layer.shadowOffset = CGSizeMake(1, 5);
    _viewBg.layer.shadowRadius = 2;
    _viewBg.layer.shadowOpacity = 0.2f;
    _viewBg.layer.borderWidth = 0.2f;
    _viewBg.layer.borderColor = color_vlight_gray.CGColor;
    
    _imgHead.layer.masksToBounds = YES;
    _imgHead.layer.cornerRadius = _imgHead.bounds.size.width * 0.5;
    _imgHead.layer.borderWidth = 2.0;
    _imgHead.layer.borderColor = color_common_red.CGColor;
    
//    _imgPic.layer.masksToBounds = YES;
//    _imgPic.layer.cornerRadius = 10;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imgPic.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imgPic.bounds;
    maskLayer.path = maskPath.CGPath;
    _imgPic.layer.mask = maskLayer;
    

//    // set the radius
//    CGFloat radius = 10.0;
//    // set the mask frame, and increase the height by the
//    // corner radius to hide bottom corners
//    CGRect maskFrame = _imgPic.bounds;
//    maskFrame.size.width += radius;
//    // create the mask layer
//    CALayer *maskLayer = [CALayer layer];
//    maskLayer.cornerRadius = radius;
//    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//    maskLayer.frame = maskFrame;
//    
//    // set the mask
//    _imgPic.layer.mask = maskLayer;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end