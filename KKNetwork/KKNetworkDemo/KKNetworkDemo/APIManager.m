//
//  APIManager.m
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (KKNetworkRequest *)checkVersionApi{
    KKNetworkRequest *request = [[KKNetworkRequest alloc]init];
    request.requestUrl = @"/about/update/checkUpdate";
    request.requestMethod = MethodPOST;
    NSString *version = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"];
    request.requestArgument = @{@"version":version};
    return request;
}

@end
