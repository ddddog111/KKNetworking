//
//  APIManager+User.m
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "APIManager+User.h"

@implementation APIManager (User)

+ (KKNetworkRequest *)loginApiWithPhoneNum:(NSString *)phoneNum AndCode:(NSString *)code{
    KKNetworkRequest *request = [KKNetworkRequest new];
    request.requestUrl = @"/login";
    request.requestArgument = @{@"phoneNum":phoneNum,@"code":code};
    request.requestTimeoutInterval = 15;
    return request;
}

@end
