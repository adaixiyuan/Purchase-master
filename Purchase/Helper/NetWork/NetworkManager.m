//
//  NetworkManager.m
//  123
//
//  Created by HeT on 15/11/18.
//  Copyright © 2015年 lh. All rights reserved.
//

#import "NetworkManager.h"

#define SANDBOX_DOCUMENT_PATH   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static const NSTimeInterval timeoutInterval = 30;

@implementation NetworkManager

// GCD单例
+ (NetworkManager *)sharedInstance
{
    static NetworkManager *__singletion = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion = [[self alloc] init];
        
    });
    
    return __singletion;
}
- (void)startRequestWithURL:(NSString *)url method:(RequestMethod)requestMethod parameters:(NSMutableDictionary *)parameters result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]init];
    if (parameters != nil) {
        parameterDic = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    }
    NSString *timeStr = [NSDate getCurrentDate];
    [parameterDic setObject:timeStr forKey:@"timestamp"];
    [parameterDic setObject:@"app" forKey:@"request_type"];
    NSString *paramStr = [NSString urlParametersStringFromParameters:parameterDic];
    NSString *md5Str = [[[kRequestKey stringByAppendingString:paramStr] stringByAppendingString:kRequestKey] getMd5_32Bit_String];
    [parameterDic setObject:md5Str forKey:@"sign"];
    
    NSLog(@"REQUEST:%@",[self urlStringWithOriginUrlString:[kHostName stringByAppendingString:url] appendParameters:parameterDic]);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:[NSURL URLWithString:kHostName]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    switch (requestMethod) {
        case RequestPost:
        {
            [manager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
                
                if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
                    // 成功
                    successBlock(operation, responseObject);
                }else{
                    // 失败
                    NSInteger code = [responseObject[@"code"] integerValue];
                    NSMutableDictionary *msg = responseObject[@"msg"];
                    NSError *error = [[NSError alloc] initWithDomain: @"ServerErrorDomain"
                                                                code: code
                                                            userInfo: @{
                                                                        NSLocalizedDescriptionKey : msg
                                                                        }];
                    if ([[responseObject objectForKey:@"code"] integerValue] == 2) {
                        
                        NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:@"loginOutTime",@"loginStatus",nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogin object:nil userInfo:userInfo];
                    }
                    failureBlock(operation, error);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // 失败
                failureBlock(operation, error);
            }];
        }
            break;
        case RequestGet:
        {
            [manager GET:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"%@",responseObject);
                
                if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
                    // 成功
                    successBlock(operation, responseObject);
                }else{
                    // 失败
                    NSInteger code = [responseObject[@"code"] integerValue];
                    NSMutableDictionary *msg = responseObject[@"msg"];
                    NSError *error = [[NSError alloc] initWithDomain: @"ServerErrorDomain"
                                                                code: code
                                                            userInfo: @{
                                                                        NSLocalizedDescriptionKey : msg
                                                                        }];
                    if ([[responseObject objectForKey:@"code"] integerValue] == 2) {
                        
                        NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:@"loginOutTime",@"loginStatus",nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogin object:nil userInfo:userInfo];
                    }
                    failureBlock(operation, error);
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                // 失败
                failureBlock(operation, error);
            }];
        }
            break;
        default:
            break;
    }
}
/**
 *  上传多个文件  Multi-Part Request
 */
- (void)uploadRequestWithURL:(NSString *)url method:(RequestMethod)requestMethod parameters:(NSMutableDictionary *)parameters datas:(NSArray *)dataArray names:(NSArray *)nameArray fileNames:(NSArray *)fileNameArray mimeTypes:(NSArray *)mimeTypeArray result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]init];
    if (parameters != nil) {
        parameterDic = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    }
    NSString *timeStr = [NSDate getCurrentDate];
    [parameterDic setObject:timeStr forKey:@"timestamp"];
    [parameterDic setObject:@"app" forKey:@"request_type"];
    NSString *paramStr = [NSString urlParametersStringFromParameters:parameterDic];
    NSString *md5Str = [[[kRequestKey stringByAppendingString:paramStr] stringByAppendingString:kRequestKey] getMd5_32Bit_String];
    [parameterDic setObject:md5Str forKey:@"sign"];
    
    // 上传文件 Multi-Part Request
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:[NSURL URLWithString:kHostName]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    [manager POST:url parameters:parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        if (dataArray.count == nameArray.count ) {
            for (NSInteger i = 0; i < dataArray.count; i++) {
                // 处理上传的数据(非空判断, 否则crash)
                NSData *data = dataArray[i];
                NSString *name = nameArray[i];
                NSString *fileName = fileNameArray[i];
                NSString *mimeType = mimeTypeArray[i];
                if (data && name && fileName && mimeType) {
                    [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
                }
            }
        }
    }success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 1) {
            // 成功
            successBlock(operation, responseObject);
        }else{
            // 失败
            NSInteger code = [responseObject[@"code"] integerValue];
            NSMutableDictionary *msg = responseObject[@"msg"];
            NSError *error = [[NSError alloc] initWithDomain: @"ServerErrorDomain"
                                                        code: code
                                                    userInfo: @{
                                                                NSLocalizedDescriptionKey : msg
                                                                }];
            if ([[responseObject objectForKey:@"code"] integerValue] == 2) {
                
                NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:@"loginOutTime",@"loginStatus",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogin object:nil userInfo:userInfo];
            }
            failureBlock(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 失败
        failureBlock(operation, error);
    }];
}


#pragma mark-
- (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSMutableDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        
        return originUrlString;
    }
}

- (NSString *)urlParametersStringFromParameters:(NSMutableDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}
- (NSString*)urlEncode:(NSString*)str {
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}
@end
