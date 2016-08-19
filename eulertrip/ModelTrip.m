//
//  ModelTrip.m
//  eulertrip
//
//  Created by ice.hu on 16/8/18.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "ModelTrip.h"

@implementation ModelTrip

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.tripID = (NSUInteger)[[attributes valueForKeyPath:@"Id"] integerValue];
    self.beginDate = [[GlobalVariables responseDateFormatter] dateFromString:[attributes objectForKey:@"BeginDate"]];
    self.endDate = [[GlobalVariables responseDateFormatter] dateFromString:[attributes objectForKey:@"EndDate"]];
    self.departed = [attributes valueForKeyPath:@"Departed"];
    self.arrived = [attributes valueForKeyPath:@"Arrived"];
    self.favorites = (NSUInteger)[[attributes valueForKeyPath:@"Favorites"] integerValue];
    
//    if ([attributes valueForKeyPath:@"imageUrl"]) {
//        self.imageURL = [NSURL URLWithString:[attributes valueForKeyPath:@"imageUrl"]];
//    }
    
    self.user = [[ModelUser alloc] initWithAttributes:[attributes valueForKeyPath:@"User"]];
    
    
    return self;
}

+(NSMutableArray *)parserResponseToObject:(NSArray *)responseArray
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in responseArray) {
        [resultArray addObject:[[ModelTrip alloc]initWithAttributes:dic]];
    }
    
    return resultArray;
}


@end
