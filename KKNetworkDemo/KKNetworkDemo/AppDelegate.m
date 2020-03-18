//
//  AppDelegate.m
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Network.h"
#import "APIManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setNetworkConfig];
    
    
    [[APIManager checkVersionApi]startWithCompletionBlockWithSuccess:^(__kindof KKNetworkRequest *request) {
        NSLog(@"版本检查 成功：%@",request.responseJSONObject);
    } failure:^(__kindof KKNetworkRequest *request) {
        NSLog(@"版本检查 失败：%@",request.error);
    }];
    
    
    return YES;
}


@end
