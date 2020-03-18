//
//  KKNetworkRequest.h
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KKNetworkRequest;
typedef void(^KKNetworkCompletionBlock)(__kindof KKNetworkRequest *request);

typedef NS_ENUM(NSInteger, KKRequestMethod) {
    MethodGET = 0,
    MethodPOST,
};

@interface KKNetworkRequest : NSObject

//请求地址
@property (nonatomic, copy) NSString *requestUrl;
//请求参数
@property (nonatomic, strong) id requestArgument;
//请求方式 可选 默认设置在config
@property (nonatomic, assign) KKRequestMethod requestMethod;
//超时时间 可选 默认设置在config
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
//http请求头 可选 默认设置在config
@property (nonatomic, copy,readonly) NSDictionary *requestHeaderFieldValueDictionary;

//返回数据
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) id responseJSONObject;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) NSString *responseString;
@property (nonatomic, strong) NSError *error;
//返回数据默认Json解析 若使用Http则不操作
@property (nonatomic, assign) BOOL isResponseSerializerTypeHTTP;

//task
@property (nonatomic, strong) NSURLSessionTask *requestTask;
///  The success callback.
@property (nonatomic, copy, nullable) KKNetworkCompletionBlock successCompletionBlock;

///  The failure callback.
@property (nonatomic, copy, nullable) KKNetworkCompletionBlock failureCompletionBlock;

//发起请求
- (void)startWithCompletionBlockWithSuccess:(KKNetworkCompletionBlock)success
                                    failure:(KKNetworkCompletionBlock)failure;

- (void)start;

- (void)stop;

//清除block
- (void)clearCompletionBlock;

//获取返回状态码
- (NSInteger)responseStatusCode;

//请求状态码校验
- (BOOL)statusCodeValidator;

@end

NS_ASSUME_NONNULL_END
