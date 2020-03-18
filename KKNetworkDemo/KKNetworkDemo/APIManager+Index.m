//
//  APIManager+Index.m
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "APIManager+Index.h"

@implementation APIManager (Index)

+ (KKNetworkRequest *)indexListApi{
    KKNetworkRequest *request = [KKNetworkRequest new];
    request.requestUrl = @"/index";
    request.requestMethod = MethodGET;
    return request;
}

@end
