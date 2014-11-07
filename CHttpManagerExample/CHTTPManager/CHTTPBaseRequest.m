//
//  CHTTPBaseRequest.m
//  CHttpManagerExample
//
//  Created by wood-spring on 14-11-7.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPBaseRequest.h"
#import "CHTTPAgent.h"

@implementation CHTTPBaseRequest


#pragma mark - 方法

- (void)start{
    [[CHTTPAgent sharedInstance] addRequest:self];
}

- (void)stop{
    [[CHTTPAgent sharedInstance] cancelRequest:self];
}

- (void)startWithCompleteBlock:(void (^)(CHTTPBaseRequest *request))successBlock failBlock:(void (^)(CHTTPBaseRequest *request))failedBlock{
    self.successCompletionBlock = successBlock;
    self.failureCompletionBlock = failedBlock;
    [self start];
}

- (void)clearCompletionBlock{
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (NSString *)completeRequestUrl{
    if (self.requestOperation) {
        return self.requestOperation.request.URL.absoluteString;
    }
    return self.requestUrl;
}

- (NSSet*)responseAcceptableContentTypes{
    return [NSSet setWithObjects:@"text/html", nil];
}

#pragma mark - 请求返回的结果

//返回response的头部信息

- (NSDictionary *)responseHeaders{
    return self.requestOperation.response.allHeaderFields;
}

- (NSString *)responseString{
    return self.requestOperation.responseString;
}

- (id)responseJSONObject{
    return self.requestOperation.responseObject;
}

- (NSInteger)responseStatusCode{
    return self.requestOperation.response.statusCode;
}

- (BOOL)isExecuting{
    return self.requestOperation.isExecuting;
}
@end
