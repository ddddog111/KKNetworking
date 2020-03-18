//
//  KKNetworkManager.h
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKNetworkRequest;

NS_ASSUME_NONNULL_BEGIN

@interface KKNetworkManager : NSObject

+ (KKNetworkManager *)sharedManager;

- (void)addRequest:(KKNetworkRequest *)request;
- (void)cancelRequest:(KKNetworkRequest *)request;
- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
