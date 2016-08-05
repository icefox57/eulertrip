// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFAppDotNetAPIClient.h"


static NSString * const AFAppDotNetAPIBaseURLString = @"http://api.eulertrip.com/";
static AFAppDotNetAPIClient *_sharedClient = nil;

@implementation AFAppDotNetAPIClient


+ (instancetype)sharedClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        
    });
    
    return _sharedClient;
}


- (void)performPOSTRequestToURL:(NSString*)postURL
                               andParameters:(NSDictionary*)parameters
                                     success:(void (^)(id _Nullable responseObject))success
                                     failure:(void (^)(id _Nonnull errorDic))failure
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [IceOAuthCredential shareCredential].accessToken] forHTTPHeaderField:@"Authorization"];
    
    
    [self POST:postURL parameters:parameters progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if Debug_DbInterface_Status
        NSLog(@"performPOSTRequestToURL~~~~~~~~~~~~responseObject~~~~~~~~~");
        NSLog(@"||JSON: %@ , P:%@", responseObject,parameters);
#endif
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ApplicationDelegate HUD].hidden = YES;
        
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        
#if Debug_DbInterface_Status
        NSLog(@"performPOSTRequestToURL~~~~~~error~~~~~~Code:%ld~~~~~",[error code]);
        NSLog(@"||url:%@",task.currentRequest.URL.absoluteString);
        NSLog(@"||Header:%@",task.currentRequest.allHTTPHeaderFields);
        NSLog(@"||errorDic: %@", errorDic);
        NSLog(@"||accessToken: %@", [IceOAuthCredential shareCredential].accessToken);
#endif
        
        
        if ([error code] == SESSION_EXPIRED_CODE) {
            
            [[IceOAuthCredential shareCredential]refreshToken:^(id  _Nullable responseObject) {
#if Debug_DbInterface_Status
                NSLog(@"------------------重新执行原请求--------------------");
#endif
                //成功重新执行原请求
                [self performPOSTRequestToURL:postURL andParameters:parameters success:^(id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(id  _Nonnull errorDic) {
                    //重新请求报错
                    failure(errorDic);
                }];
            } failure:^(id  _Nonnull errorDic) {
                //删除token
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_UserCredentialDic];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //$$$$$$$$$
                
                NSDictionary *dic = @{API_ErrorMessage:@"验证过期请重新登入!"};
                //获取token报错
                failure(dic);
            }];
        }
        //请求失败报错
        failure(errorDic);
    }];
}

- (void)performGetRequestToURL:(NSString*)postURL
                  andParameters:(NSDictionary*)parameters
                        success:(void (^)(id _Nullable responseObject))success
                        failure:(void (^)(id _Nonnull errorDic))failure
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [IceOAuthCredential shareCredential].accessToken] forHTTPHeaderField:@"Authorization"];
    
    
    [self GET:postURL parameters:parameters progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if Debug_DbInterface_Status
           NSLog(@"performGetRequestToURL~~~~~~~~~~~~responseObject~~~~~~~~~");
           NSLog(@"||JSON: %@ , P:%@", responseObject,parameters);
#endif
           success(responseObject);
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [ApplicationDelegate HUD].hidden = YES;
           
           NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
           NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
           
#if Debug_DbInterface_Status
           NSLog(@"performGetRequestToURL~~~~~~error~~~~~~Code:%ld~~~~~",[error code]);
           NSLog(@"||url:%@",task.currentRequest.URL.absoluteString);
           NSLog(@"||Header:%@",task.currentRequest.allHTTPHeaderFields);
           NSLog(@"||errorDic: %@", errorDic);
           NSLog(@"||accessToken: %@", [IceOAuthCredential shareCredential].accessToken);
#endif
           
           
           if ([error code] == SESSION_EXPIRED_CODE) {
               
               [[IceOAuthCredential shareCredential]refreshToken:^(id  _Nullable responseObject) {
#if Debug_DbInterface_Status
                   NSLog(@"------------------重新执行原请求--------------------");
#endif
                   //成功重新执行原请求
                   [self performPOSTRequestToURL:postURL andParameters:parameters success:^(id  _Nullable responseObject) {
                       success(responseObject);
                   } failure:^(id  _Nonnull errorDic) {
                       //重新请求报错
                       failure(errorDic);
                   }];
               } failure:^(id  _Nonnull errorDic) {
                   //删除token
                   [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_UserCredentialDic];
                   [[NSUserDefaults standardUserDefaults]synchronize];
                   //$$$$$$$$$
                   
                   NSDictionary *dic = @{API_ErrorMessage:@"验证过期请重新登入!"};
                   //获取token报错
                   failure(dic);
               }];
           }
           //请求失败报错
           failure(errorDic);
       }];
}

@end
