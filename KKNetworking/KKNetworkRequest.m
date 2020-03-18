//
//  KKNetworkRequest.m
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import "KKNetworkRequest.h"
#import "KKNetworkManager.h"

@implementation KKNetworkRequest

- (void)startWithCompletionBlockWithSuccess:(KKNetworkCompletionBlock)success
                                    failure:(KKNetworkCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

#pragma mark - Request Action

- (void)start {
    [[KKNetworkManager sharedManager] addRequest:self];
}

- (void)stop {
    [[KKNetworkManager sharedManager] cancelRequest:self];
}

- (NSInteger)responseStatusCode{
    NSHTTPURLResponse *response = (NSHTTPURLResponse*)self.requestTask.response;
    return response.statusCode;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {//http请求成功
        return YES;
    } else {
        return NO;
    }
}

- (void)setCompletionBlockWithSuccess:(KKNetworkCompletionBlock)success
                              failure:(KKNetworkCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}


@end
