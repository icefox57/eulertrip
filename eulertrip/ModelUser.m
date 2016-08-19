//
//  ModelUser.m
//  eulertrip
//
//  Created by ice.hu on 16/8/18.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "ModelUser.h"

@implementation ModelUser

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userID = (NSUInteger)[[attributes valueForKeyPath:@"Id"] integerValue];
    self.mobile = [attributes valueForKeyPath:@"Mobile"];
    self.nickName = [attributes valueForKeyPath:@"NickName"];
    self.sex = [attributes valueForKeyPath:@"Sex"];
    self.birth = [attributes valueForKeyPath:@"Birth"];
    
    //    if ([attributes valueForKeyPath:@"imageUrl"]) {
    //        self.imageURL = [NSURL URLWithString:[attributes valueForKeyPath:@"imageUrl"]];
    //    }
    
    return self;
}

@end
