//
//  ModelTrip.h
//  eulertrip
//
//  Created by ice.hu on 16/8/18.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVariables.h"
#import "ModelUser.h"

@interface ModelTrip : NSObject

@property (nonatomic, assign) NSUInteger tripID;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *departed;
@property (nonatomic, strong) NSString *arrived;

@property (nonatomic, assign) NSUInteger favorites;

@property (nonatomic, strong) NSURL *imageURL;

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

@property (nonatomic, strong) ModelUser *user;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+(NSMutableArray *)parserResponseToObject:(NSArray *)responseArray;

@end
