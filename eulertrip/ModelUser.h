//
//  ModelUser.h
//  eulertrip
//
//  Created by ice.hu on 16/8/18.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVariables.h"

@interface ModelUser : NSObject

@property (nonatomic, assign) NSUInteger userID;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birth;


@property (nonatomic, strong) NSURL *imageURL;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
