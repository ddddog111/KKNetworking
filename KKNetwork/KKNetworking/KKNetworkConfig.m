//
//  KKNetworkConfig.m
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import "KKNetworkConfig.h"
@implementation KKNetworkConfig

+ (KKNetworkConfig *)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestMethod = MethodPOST;
        _requestTimeoutInterval = 20;
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _debugLogEnabled = NO;
        _requestHeaderFieldValueDictionary = @{@"Content-type":@"application/json"};
    }
    return self;
}

@end
