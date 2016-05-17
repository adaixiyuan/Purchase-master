//
//  NetworkManager.h
//  123
//
//  Created by HeT on 15/11/18.
//  Copyright © 2015年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef NS_ENUM(NSInteger , RequestMethod) {
    RequestGet = 0,
    RequestPost,  //URL-Form-Encoded Request
};

@interface NetworkManager : NSObject

// GCD单例
+ (NetworkManager *)sharedInstance;
/**
 *  网络请求  POST && GET
 */
- (void)startRequestWithURL:(NSString *)url method:(RequestMethod)requestMethod parameters:(NSMutableDictionary *)parameters result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  上传多个文件  Multi-Part Request
 */
- (void)uploadRequestWithURL:(NSString *)url method:(RequestMethod)requestMethod parameters:(NSMutableDictionary *)parameters datas:(NSArray *)dataArray names:(NSArray *)nameArray fileNames:(NSArray *)fileNameArray mimeTypes:(NSArray *)mimeTypeArray result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end
