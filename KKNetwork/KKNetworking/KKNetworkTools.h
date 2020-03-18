//
//  KKNetworkTools.h
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKNetworkRequest.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void KKLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface KKNetworkTools : NSObject

+ (NSString *)md5StringFromString:(NSString *)string;
+ (NSStringEncoding)stringEncodingWithRequest:(KKNetworkRequest *)request;

@end

NS_ASSUME_NONNULL_END
