//
//  KKNetworkConfig.h
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "KKNetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKNetworkConfig : NSObject

+ (KKNetworkConfig *)sharedConfig;

//debug模式下是否log
@property (nonatomic) BOOL debugLogEnabled;

//服务器地址
@property (nonatomic, copy) NSString *baseUrl;

//https认证
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
//全局默认请求方式
@property (nonatomic, assign) KKRequestMethod requestMethod;
//全局超时时间
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
//全局 http头
@property (nonatomic, copy) NSDictionary *requestHeaderFieldValueDictionary;


@end

NS_ASSUME_NONNULL_END
