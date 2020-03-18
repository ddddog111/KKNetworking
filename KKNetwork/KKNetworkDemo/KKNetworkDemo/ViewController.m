//
//  ViewController.m
//  KKNetworkDemo
//
//  Created by keke on 2020/3/18.
//  Copyright © 2020 kk. All rights reserved.
//

#import "ViewController.h"
#import "APIManager+User.h"
#import "APIManager+Index.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //example
    
    [[APIManager indexListApi]startWithCompletionBlockWithSuccess:^(__kindof KKNetworkRequest *request) {
        NSLog(@"首页列表 成功：%@",request.responseJSONObject);
    } failure:^(__kindof KKNetworkRequest *request) {
        NSLog(@"首页列表 失败：%@",request.error);
    }];
    
    [[APIManager loginApiWithPhoneNum:@"1333333333" AndCode:@"4532"]startWithCompletionBlockWithSuccess:^(__kindof KKNetworkRequest *request) {
        NSLog(@"登录 成功：%@",request.responseJSONObject);
    } failure:^(__kindof KKNetworkRequest *request) {
        NSLog(@"登录 失败：%@",request.error);
    }];
    
}


@end
