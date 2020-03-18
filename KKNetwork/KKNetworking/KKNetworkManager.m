//
//  KKNetworkManager.m
//  test
//
//  Created by keke on 2020/3/16.
//  Copyright © 2020 keke. All rights reserved.
//

#import "KKNetworkManager.h"
#import "KKNetworkConfig.h"
#import "AFNetworking.h"
#import "KKNetworkRequest.h"
#import "KKNetworkTools.h"
#import <pthread/pthread.h>

@implementation KKNetworkManager{
    AFHTTPSessionManager *_manager;
    KKNetworkConfig *_config;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
    NSMutableDictionary<NSNumber *, KKNetworkRequest *> *_requestsRecord;

    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

+ (KKNetworkManager *)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _config = [KKNetworkConfig sharedConfig];
        _manager = [[AFHTTPSessionManager alloc] init];
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.kk.network", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        //加锁
        pthread_mutex_init(&_lock, NULL);

        _manager.securityPolicy = _config.securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // Take over the status code validation
        _manager.responseSerializer.acceptableStatusCodes = _allStatusCodes;
        _manager.completionQueue = _processingQueue;
    }
    return self;
}

- (void)addRequest:(KKNetworkRequest *)request{
    NSParameterAssert(request != nil);
    NSError * __autoreleasing error = nil;
    
    NSString *url = [self buildRequestUrl:request];
    id param = request.requestArgument;
    //task没有 取config默认的
    KKRequestMethod method = request.requestMethod;
    if (!method) {
        method = [KKNetworkConfig sharedConfig].requestMethod;
    }
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    NSURLSessionTask *requestTask = nil;
    
    switch (method) {
    case MethodGET:
         requestTask =  [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param error:&error];
    case MethodPOST:
         requestTask =  [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param error:&error];
    }
    
    if (error) {
           [self requestDidFailWithRequest:request error:error];
           return;
    }
    NSAssert(requestTask != nil, @"requestTask should not be nil");
    
    KKLog(@"Add request: %@", url);
    request.requestTask = requestTask;
    
    [self addRequestToRecord:request];
    [requestTask resume];
}

//请求地址拼接
- (NSString *)buildRequestUrl:(KKNetworkRequest *)request {
    NSParameterAssert(request != nil);

    NSString *detailUrl = [request requestUrl];
    NSURL *temp = [NSURL URLWithString:detailUrl];
    // If detailUrl is valid URL
    if (temp && temp.host && temp.scheme) {
        return detailUrl;
    }

    NSString *baseUrl = [_config baseUrl];
    // URL slash compability
    NSURL *url = [NSURL URLWithString:baseUrl];

    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }

    return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}

//请求序列化
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(KKNetworkRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    
    //默认使用Json序列化
    requestSerializer = [AFJSONRequestSerializer serializer];

    //超时时间设置
    requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    if (requestSerializer.timeoutInterval) {
        requestSerializer.timeoutInterval = [KKNetworkConfig sharedConfig].requestTimeoutInterval;
    }

    //请求头设置
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = request.requestHeaderFieldValueDictionary;
    if (headerFieldValueDictionary == nil) {
        headerFieldValueDictionary = [KKNetworkConfig sharedConfig].requestHeaderFieldValueDictionary;
    }
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

- (void)addRequestToRecord:(KKNetworkRequest *)request{
    pthread_mutex_lock(&_lock);
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    pthread_mutex_unlock(&_lock);
}

- (void)removeRequestFromRecord:(KKNetworkRequest *)request {
    pthread_mutex_lock(&_lock);
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
//    KKLog(@"Request queue size = %zd", [_requestsRecord count]);
    pthread_mutex_unlock(&_lock);
}

- (void)cancelRequest:(KKNetworkRequest *)request {
    NSParameterAssert(request != nil);
    
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests{
    pthread_mutex_lock(&_lock);
    NSArray *allKeys = [_requestsRecord allKeys];
    pthread_mutex_unlock(&_lock);
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            pthread_mutex_lock(&_lock);
            KKNetworkRequest *request = _requestsRecord[key];
            pthread_mutex_unlock(&_lock);
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];

    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [_manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
         [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];

    return dataTask;
}

#pragma mark 请求完成

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    pthread_mutex_lock(&_lock);
    KKNetworkRequest *request = _requestsRecord[@(task.taskIdentifier)];
    pthread_mutex_unlock(&_lock);

    // When the request is cancelled and removed from records, the underlying
    // AFNetworking failure callback will still kicks in, resulting in a nil `request`.
    //
    // Here we choose to completely ignore cancelled tasks. Neither success or failure
    // callback will be called.
    if (!request) {
        return;
    }
    
    KKLog(@"Finished Request: %@", request.requestUrl);
    
    NSError * __autoreleasing serializationError = nil;
    NSError * __autoreleasing validationError = nil;

    NSError *requestError = nil;
    BOOL succeed = NO;

    
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
        request.responseString = [[NSString alloc] initWithData:responseObject encoding:[KKNetworkTools stringEncodingWithRequest:request]];
        
        //默认Json解析
        if (!request.isResponseSerializerTypeHTTP) {
            request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
            request.responseJSONObject = request.responseObject;
        }
    }
    if (error) {
        succeed = NO;
        requestError = error;
    } else if (serializationError) {
        succeed = NO;
        requestError = serializationError;
    } else {
        succeed = [self validateResult:request error:&validationError];
        requestError = validationError;
    }
   
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}

//返回数据json序列化
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;

    }
    return _jsonResponseSerializer;
}

//返回结果校验（主要是code校验 可在外面进行处理）
- (BOOL)validateResult:(KKNetworkRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    NSString *errorDomain = @"com.kk.request.validation";
    NSInteger errorInvalidStatusCode = -8;
    //错误码验证
    BOOL result = [request statusCodeValidator];
    if (!result) {
        if (error) {
            *error = [NSError errorWithDomain:errorDomain code:errorInvalidStatusCode userInfo:@{NSLocalizedDescriptionKey:@"Invalid status code"}];
        }
        return result;
    }
    return YES;
}

//成功回调
- (void)requestDidSucceedWithRequest:(KKNetworkRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}
//失败回调
- (void)requestDidFailWithRequest:(KKNetworkRequest *)request error:(NSError *)error {
    request.error = error;
    
    KKLog(@"Request %@ failed, status code = %ld, error = %@",
           request.requestUrl, (long)[request responseStatusCode], error.localizedDescription);

    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}


@end
