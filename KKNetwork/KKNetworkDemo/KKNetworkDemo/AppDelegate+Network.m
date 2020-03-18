//
//  AppDelegate+Network.m
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "AppDelegate+Network.h"
#import "KKNetworking.h"

@implementation AppDelegate (Network)

- (void)setNetworkConfig{
    
    [[KKNetworkConfig sharedConfig] setBaseUrl:@"https://www.baidu.com/"];
    [[KKNetworkConfig sharedConfig] setRequestMethod:MethodPOST];
    [[KKNetworkConfig sharedConfig] setRequestTimeoutInterval:20];
    [[KKNetworkConfig sharedConfig] setRequestHeaderFieldValueDictionary:[self getRequestHeader]];
}

- (NSDictionary *)getRequestHeader{
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
     [dic setValue:@"ios" forKey:@"secId"];
     NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
        [dic setValue:token forKey:@"token"];
    }
    return dic;
}
@end
