//
//  IceOAuthCredential.h
//  eulertrip
//
//  Created by ice.hu on 16/7/27.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IceOAuthCredential : NSObject

@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable accessToken;
@property (nonatomic, copy) NSString * _Nullable tokenType;
@property (nonatomic, copy) NSString * _Nullable refreshToken;
@property (nonatomic, copy) NSDate * _Nullable expiresDate;

+ (IceOAuthCredential * _Nullable)shareCredential;

+(void)setNewCredential:(NSDictionary * _Nullable)dic;

+(void)getTempAccesstoken:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(id _Nonnull errorDic))failure;

+(void)getUserAccessToekn:(NSString * _Nullable)username
                 password:(NSString * _Nullable)password
                  success:(nullable void (^)(id _Nullable responseObject))success
                  failure:(nullable void (^)(id _Nonnull errorDic))failure;

-(void) refreshToken:(nullable void (^)(id _Nullable responseObject))success
             failure:(nullable void (^)(id _Nonnull errorDic))failure;

+(BOOL)isTokenExpires;
+(BOOL)isNeedLogin;
@end
