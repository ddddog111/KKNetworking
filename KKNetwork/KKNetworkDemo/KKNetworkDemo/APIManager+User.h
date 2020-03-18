//
//  APIManager+User.h
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager (User)

+ (KKNetworkRequest *)loginApiWithPhoneNum:(NSString *)phoneNum AndCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
