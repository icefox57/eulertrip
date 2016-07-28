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
#import "IceOAuthCredential.h"

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


- (NSURLSessionTask*)performPOSTRequestToURL:(NSString*)postURL
                               andParameters:(NSDictionary*)parameters
                                     success:(void (^)(id _Nullable responseObject))success
                                     failure:(void (^)(id _Nonnull errorDic))failure
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [IceOAuthCredential shareCredential].accessToken] forHTTPHeaderField:@"Authorization"];
    
    
    __block NSURLSessionDataTask *task = [self POST:postURL parameters:parameters progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if Debug_DbInterface_Status
        NSLog(@"~~~~~~~~~~~~responseObject~~~~~~~~~");
        NSLog(@"JSON: %@ , P:%@", responseObject,parameters);
#endif
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ApplicationDelegate HUD].hidden = YES;
        
        NSData *errorData  = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary * errorDic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        
#if Debug_DbInterface_Status
        NSLog(@"~~~~~~error~~~~~~Code:%ld~~~~~",[error code]);
        NSLog(@"errorDic: %@", errorDic);
#endif
        
        
        if ([error code] == SESSION_EXPIRED_CODE) {
            
            [[IceOAuthCredential shareCredential]refreshToken:^(id  _Nullable responseObject) {
                //成功重新执行原请求
                [self performPOSTRequestToURL:postURL andParameters:parameters success:^(id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(id  _Nonnull errorDic) {
                    failure(errorDic);
                }];
            } failure:^(id  _Nonnull errorDic) {
                failure(errorDic);
            }];
        }
        failure(errorDic);
    }];
    [task resume];
    return task;
}


/*
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSMutableURLRequest *)urlRequest completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))originalCompletionHandler{
    
         //create a completion block that wraps the original
         void (^authFailBlock)(NSURLResponse *response, id responseObject, NSError *error) = ^(NSURLResponse *response, id responseObject, NSError *error)
         {
                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                 if([httpResponse statusCode] == 401){
            
                         //如果access token过期，返回错误，调用此block
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                                 //调用refreshAccesstoken方法，刷新access token。
                                 [self refreshAccessToken:^(AFHTTPRequestOperation *operation) {
                                         //存取新的access token，此处我使用了KeyChain存取
                                         NSDictionary *headerInfo = operation.response.allHeaderFields;
                                         NSString *newAccessToken = [headerInfo objectForKey:@"access-token"];
                                         NSString *newRefreshToken = [headerInfo objectForKey:@"refresh-token"];
                                         [SSKeychain deletePasswordForService:@"<key>" account:@"access-token"];
                                         [SSKeychain deletePasswordForService:@"<key>" account:@"refresh-token"];
                                         [SSKeychain setPassword:newAccessToken forService:@"<key>" account:@"access-token"];
                                         [SSKeychain setPassword:newRefreshToken forService:@"<key>" account:@"refresh-token"];
                    
                                         //将新的access token加入到原来的请求体中，重新发送请求。
                                         [urlRequest setValue:newAccessToken forHTTPHeaderField:@"access-token"];
                    
                                         NSURLSessionDataTask *originalTask = [super dataTaskWithRequest:urlRequest completionHandler:originalCompletionHandler];
                                         [originalTask resume];
                                     }];
                             });
                     }else{
                             NSLog(@"no auth error");
                             originalCompletionHandler(response, responseObject, error);
                         }
             };
    
         NSURLSessionDataTask *stask = [super dataTaskWithRequest:urlRequest completionHandler:authFailBlock];
    
         return stask;
    
     };



 -(void)refreshAccessToken:(void(^)(AFHTTPRequestOperation *responseObject))refresh{
         NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:@"<yourURL>"];
    
         [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
         //将原来的access token和refresh token发送给服务器，以获取新的token
         NSString *accessToken = [SSKeychain passwordForService:@"<key>" account:@"access-token"];
         NSString *refreshToken = [SSKeychain passwordForService:@"<key>" account:@"refresh-token"];
    
         [request setValue:accessToken forHTTPHeaderField:@"access-token"];
         [request setValue:refreshToken forHTTPHeaderField:@"refresh-token"];
     
         //执行网络方法
         AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject) {
                 refresh(operation);
             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                     refresh(operation);
                 }];
         [httpRequestOperation start];
     }*/

@end
