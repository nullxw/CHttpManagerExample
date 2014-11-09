//
//  CHTTPManager.m
//  CHttpManagerExample
//
//  Created by outman on 14-11-9.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPManager.h"

@implementation CHTTPManager

+ (CHTTPManager *)manager{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (CHTTPRequest *)chttp_requestWithUrl:(NSString *)url arguments:(id)argumets tag:(NSString *)tag methodType:(CHTTPRequestMethod)methodType cacheSeconds:(NSInteger)seconds successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    CHTTPRequest *request = [[CHTTPRequest alloc] init];
    request.requestMethod = methodType;
    request.cacheTimeInSeconds = seconds;
    request.tag = tag;
    request.requestArguments = argumets;
    if (self.baseUrl) {
        request.requestUrl = [self.baseUrl stringByAppendingString:url];
    }else{
        request.requestUrl = url;
    }
    [request startWithCompleteBlock:successBlock failBlock:failBlock];
    return request;
}

+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:nil tag:nil methodType:CHTTPRequestMethodGet cacheSeconds:0 successBlock:successBlock failBlock:failBlock];
}

+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url tag:(NSString*)tag successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:nil tag:tag methodType:CHTTPRequestMethodGet cacheSeconds:0 successBlock:successBlock failBlock:failBlock];
}

+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url cahceSeconds:(NSInteger)seconds successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:nil tag:nil methodType:CHTTPRequestMethodGet cacheSeconds:seconds successBlock:successBlock failBlock:failBlock];
}

+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url cahceSeconds:(NSInteger)seconds tag:(NSString*)tag successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:nil tag:tag methodType:CHTTPRequestMethodGet cacheSeconds:seconds successBlock:successBlock failBlock:failBlock];
}



+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url arguments:(id)arguments successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:arguments tag:nil methodType:CHTTPRequestMethodPost cacheSeconds:0 successBlock:successBlock failBlock:failBlock];

}
+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url tag:(NSString*)tag arguments:(id)arguments successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:arguments tag:tag methodType:CHTTPRequestMethodPost cacheSeconds:0 successBlock:successBlock failBlock:failBlock];

}
+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url arguments:(id)arguments cacheSeconds:(NSInteger)seconds successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:arguments tag:nil methodType:CHTTPRequestMethodPost cacheSeconds:seconds successBlock:successBlock failBlock:failBlock];

}
+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url arguments:(id)arguments cacheSeconds:(NSInteger)seconds tag:(NSString*)tag successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock{
    return [[CHTTPManager manager] chttp_requestWithUrl:url arguments:arguments tag:tag methodType:CHTTPRequestMethodPost cacheSeconds:seconds successBlock:successBlock failBlock:failBlock];
}
@end
