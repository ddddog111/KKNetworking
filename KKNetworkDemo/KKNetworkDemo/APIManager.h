//
//  APIManager.h
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (KKNetworkRequest *)checkVersionApi;

@end

NS_ASSUME_NONNULL_END
