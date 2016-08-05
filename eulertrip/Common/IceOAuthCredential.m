//
//  IceOAuthCredential.m
//  eulertrip
//
//  Created by ice.hu on 16/7/27.
//  Copyright © 2016年 eulertrip. All rights reserved.
//

#import "IceOAuthCredential.h"
#import "AFAppDotNetAPIClient.h"
#import "GlobalVariables.h"
#import "MD5Util.h"
#import "DLUDID.h"

@implementation IceOAuthCredential
static IceOAuthCredential *_instance            = nil;


+ (IceOAuthCredential *)shareCredential{
    if (_instance == nil){
        if (![[NSUserDefaults standardUserDefaults] objectForKey:UD_UserCredentialDic]) {
            return nil;
        }
        
        _instance = [[IceOAuthCredential alloc] init];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:UD_UserCredentialDic];
        
#if Debug_DbInterface_Status
        NSLog(@"UD_UserCredentialDic:%@",dic);
#endif
        
        _instance.accessToken = [dic objectForKey:API_OAuth_accesstoken];
        _instance.refreshToken = [dic objectForKey:API_OAuth_refreshtoken];
        _instance.tokenType = [dic objectForKey:API_OAuth_token_type];
        _instance.expiresDate = [dic objectForKey:API_OAuth_expires_date];
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_UserId]) {
            _instance.userId = [[NSUserDefaults standardUserDefaults]objectForKey:UD_UserId];
        }

    }
    return _instance;
}

+(void)setNewCredential:(NSDictionary *)dic
{
    if ([dic objectForKey:API_OAuth_accesstoken]) {
        _instance.accessToken = [dic objectForKey:API_OAuth_accesstoken];
    }
    if ([dic objectForKey:API_OAuth_refreshtoken]) {
        _instance.refreshToken = [dic objectForKey:API_OAuth_refreshtoken];
    }
    if ([dic objectForKey:API_OAuth_token_type]) {
        _instance.tokenType = [dic objectForKey:API_OAuth_token_type];
    }
    if ([dic objectForKey:API_OAuth_expires_date]) {
        _instance.expiresDate = [dic objectForKey:API_OAuth_expires_date];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:UD_UserCredentialDic];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+(BOOL)isNeedLogin{
    if (!_instance) {
        return YES;
    }
    
    NSLog(@"--------isNeedLogin ---refreshToken:%@,userId:%@",_instance.refreshToken,_instance.userId);
    
    if (!_instance.refreshToken || [_instance.refreshToken isEqualToString:@""] ||
        !_instance.userId || [_instance.userId isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+(BOOL)isTokenExpires{
    if (!_instance) {
        return YES;
    }

    //过期
    if ([_instance.expiresDate compare:[NSDate date]] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+(void)getTempAccesstoken:(void (^)(id _Nullable responseObject))success
                  failure:(void (^)(id _Nonnull errorDic))failure{
    //-----调用接口-------
    NSDictionary *parameters = @{@"grant_type":@"client_credentials",API_OAuth_deviceID:[DLUDID value]};
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [[AFAppDotNetAPIClient sharedClient] POST:@"OAuth/Token" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //转换过期时间
        NSDate *expireDate = [NSDate distantFuture];
        id expiresIn = [responseObject valueForKey:API_OAuth_expires_in];
        if (expiresIn && ![expiresIn isEqual:[NSNull null]]) {
            expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
        }
        
        //生成字典
        
        NSDictionary *dic = @{API_OAuth_accesstoken:[responseObject valueForKey:API_OAuth_accesstoken],
//                              API_OAuth_refreshtoken:[responseObject valueForKey:API_OAuth_refreshtoken],
                              API_OAuth_expires_date:expireDate,
                              API_OAuth_token_type:[responseObject valueForKey:API_OAuth_token_type]};
        //保存
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:UD_UserCredentialDic];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([dic objectForKey:API_OAuth_accesstoken]) {
            _instance.accessToken = [dic objectForKey:API_OAuth_accesstoken];
        }
        if ([dic objectForKey:API_OAuth_refreshtoken]) {
            _instance.refreshToken = [dic objectForKey:API_OAuth_refreshtoken];
        }
        if ([dic objectForKey:API_OAuth_token_type]) {
            _instance.tokenType = [dic objectForKey:API_OAuth_token_type];
        }
        if ([dic objectForKey:API_OAuth_expires_date]) {
            _instance.expiresDate = [dic objectForKey:API_OAuth_expires_date];
        }
        
        
#if Debug_DbInterface_Status
        NSLog(@"getTempAccesstoken--------JSON: %@ , P:%@ , head:%@", responseObject,parameters,task.currentRequest.allHTTPHeaderFields);
        NSLog(@"-----token:%@",[IceOAuthCredential shareCredential].accessToken);
#endif
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
#if Debug_DbInterface_Status
        NSLog(@"getTempAccesstoken~~~~~~error~~~~~~Code:%ld~~~~~",[error code]);
        NSLog(@"errorDic: %@", errorDic);
#endif
        
        failure(errorDic);
    }];
}

+(void)getUserAccessToekn:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(id _Nullable responseObject))success
                  failure:(void (^)(id _Nonnull errorDic))failure{
    
    //-----调用接口-------
    NSDictionary *parameters = @{@"grant_type":@"password",
                                 @"username":username,
                                 @"password":[MD5Util md5:password],
                                 API_OAuth_deviceID:[DLUDID value]};
    
    NSLog(@"~~~~~~P:%@",parameters);
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [[AFAppDotNetAPIClient sharedClient] POST:@"OAuth/Token" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if Debug_DbInterface_Status
        NSLog(@"getUserAccessToekn----------JSON: %@ , P:%@", responseObject,parameters);
#endif

        //转换过期时间
        NSDate *expireDate = [NSDate distantFuture];
        id expiresIn = [responseObject valueForKey:API_OAuth_expires_in];
        if (expiresIn && ![expiresIn isEqual:[NSNull null]]) {
            expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
        }
        
        //生成字典
        NSDictionary *dic = @{API_OAuth_accesstoken:[responseObject valueForKey:API_OAuth_accesstoken],
                              API_OAuth_refreshtoken:[responseObject valueForKey:API_OAuth_refreshtoken],
                              API_OAuth_expires_date:expireDate,
                                API_OAuth_token_type:[responseObject valueForKey:API_OAuth_token_type]};
        //保存
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:UD_UserCredentialDic];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([dic objectForKey:API_OAuth_accesstoken]) {
            _instance.accessToken = [dic objectForKey:API_OAuth_accesstoken];
        }
        if ([dic objectForKey:API_OAuth_refreshtoken]) {
            _instance.refreshToken = [dic objectForKey:API_OAuth_refreshtoken];
        }
        if ([dic objectForKey:API_OAuth_token_type]) {
            _instance.tokenType = [dic objectForKey:API_OAuth_token_type];
        }
        if ([dic objectForKey:API_OAuth_expires_date]) {
            _instance.expiresDate = [dic objectForKey:API_OAuth_expires_date];
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        
#if Debug_DbInterface_Status
        NSLog(@"getUserAccessToekn~~~~~~error~~~~~~Code:%ld~~~~~",(long)[error code]);
        NSLog(@"parament:%@ -- errorDic: %@",parameters, errorDic);
#endif
        failure(errorDic);
    }];
}


-(void)refreshAccessToekn:(void (^)(id _Nullable responseObject))success
                  failure:(void (^)(id _Nonnull errorDic))failure{
    
    //-----调用接口-------
    NSDictionary *parameters = @{@"grant_type":API_OAuth_refreshtoken,
                                 API_OAuth_refreshtoken:[IceOAuthCredential shareCredential].refreshToken};
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [[AFAppDotNetAPIClient sharedClient] POST:@"OAuth/Token" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if Debug_DbInterface_Status
        NSLog(@"refreshAccessToekn------JSON: %@ , P:%@", responseObject,parameters);
#endif
        
        //转换过期时间
        NSDate *expireDate = [NSDate distantFuture];
        id expiresIn = [responseObject valueForKey:API_OAuth_expires_in];
        if (expiresIn && ![expiresIn isEqual:[NSNull null]]) {
            expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
        }
        
        //生成字典
        NSDictionary *dic = @{API_OAuth_accesstoken:[responseObject valueForKey:API_OAuth_accesstoken],
                              API_OAuth_refreshtoken:[responseObject valueForKey:API_OAuth_refreshtoken],
                              API_OAuth_expires_date:expireDate,
                              API_OAuth_token_type:[responseObject valueForKey:API_OAuth_token_type]};
        //保存
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:UD_UserCredentialDic];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([dic objectForKey:API_OAuth_accesstoken]) {
            _instance.accessToken = [dic objectForKey:API_OAuth_accesstoken];
        }
        if ([dic objectForKey:API_OAuth_refreshtoken]) {
            _instance.refreshToken = [dic objectForKey:API_OAuth_refreshtoken];
        }
        if ([dic objectForKey:API_OAuth_token_type]) {
            _instance.tokenType = [dic objectForKey:API_OAuth_token_type];
        }
        if ([dic objectForKey:API_OAuth_expires_date]) {
            _instance.expiresDate = [dic objectForKey:API_OAuth_expires_date];
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        
#if Debug_DbInterface_Status
        NSLog(@"refreshAccessToekn~~~~~~error~~~~~~Code:%ld~~~~~",[error code]);
        NSLog(@"||errorDic: %@", errorDic);
        NSLog(@"||parameters: %@", parameters);
#endif
        failure(errorDic);
    }];
}

-(void) refreshToken:(void (^)(id _Nullable responseObject))success
             failure:(void (^)(id _Nonnull errorDic))failure{
    //重新请求临时Token
    if (!_instance || !_instance.refreshToken || [_instance.refreshToken isEqualToString:@""]) {
        [IceOAuthCredential getTempAccesstoken:^(id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(id  _Nonnull errorDic) {
            failure(errorDic);
        }];
    }
    //刷新用户Token
    else{
        [self refreshAccessToekn:^(id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(id  _Nonnull errorDic) {
            failure(errorDic);
        }];
    }
}

@end
