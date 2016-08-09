//
//  MapTableViewCell.h
//  eulertrip
//
//  Created by ice.hu on 16/8/8.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
@interface MapTableViewCell : UITableViewCell<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapView;


@end
