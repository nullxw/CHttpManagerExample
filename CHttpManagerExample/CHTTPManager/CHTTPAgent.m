//
//  CHTTPAgent.m
//  CHttpManagerExample
//
//  Created by wood-spring on 14-11-7.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPAgent.h"
#import "AFDownloadRequestOperation.h"




@implementation CHTTPAgent{
#pragma mark - 私有变量
    AFHTTPRequestOperationManager *_manager; //AFNetwork管理Http请求方法
    NSMutableDictionary *_requestsRecord;   //所有正在请求的记录
}


+ (CHTTPAgent *)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}


- (void)addRequest:(CHTTPBaseRequest *)request{
    id requestArguments = [request requestArguments];//获取请求的参数列表
    NSString *requestUrl = [request requestUrl]; //获取请求的路径
    if ([request requestSerializerType] == CHTTPRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else{
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    // 如果请求需要认证 填写认证信息
    if (request.requestAuthorizationDictionary) {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:request.requestAuthorizationDictionary[@"username"] password:request.requestAuthorizationDictionary[@"password"]];
    }
    
    NSURLRequest *customRequest = [request customRequest];
    if (customRequest) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:customRequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation error:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation error:error];
        }];
        request.requestOperation = operation;
        [_manager.operationQueue addOperation:operation];
    }else{
        switch (request.requestMethod) {
            case CHTTPRequestMethodGet:
            {
                if (request.requestDownloadPath){
                    NSURLRequest *downloadRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
                    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:downloadRequest targetPath:request.requestDownloadPath shouldResume:request.shouldResume];
                    [operation setProgressiveDownloadProgressBlock:request.downloadProgressBlock];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self handleRequestResult:operation error:nil];
                    }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self handleRequestResult:operation error:error];
                    }];
                    request.requestOperation = operation;
                    [_manager.operationQueue addOperation:operation];
                }else{
                    request.requestOperation = [_manager GET:requestUrl parameters:requestArguments success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self handleRequestResult:operation error:nil];
                    }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self handleRequestResult:operation error:error];
                    }];
                }
            }
                break;
                case CHTTPRequestMethodPost:
            {
                if (request.constructingBodyBlock) {
                    request.requestOperation = [_manager POST:requestUrl parameters:requestArguments constructingBodyWithBlock:request.constructingBodyBlock
                                                      success:^(AFHTTPRequestOperation *    operation, id responseObject) {
                                                          [self handleRequestResult:operation error:nil];
                                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                          [self handleRequestResult:operation error:error];
                                                      }];
                }else{
                    request.requestOperation = [_manager POST:requestUrl parameters:requestArguments success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self handleRequestResult:operation error:nil];
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self handleRequestResult:operation error:error];
                    }];
                }
            }
                case CHTTPRequestMethodHead:
            {
                request.requestOperation = [_manager HEAD:requestUrl parameters:requestArguments success:^(AFHTTPRequestOperation *operation) {
                    [self handleRequestResult:operation error:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation error:error];
                }];
            }
                case CHTTPRequestMethodDelete:
            {
                request.requestOperation = [_manager PUT:requestUrl parameters:requestArguments success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation error:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation error:error];
                }];
            }
                case CHTTPRequestMethodPut:
            {
                request.requestOperation = [_manager DELETE:requestUrl parameters:requestArguments success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self handleRequestResult:operation error:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self handleRequestResult:operation error:error];
                }];
            }
            default:
                CJSONLOG(@"不合法的请求方法");
                break;
        }
    }
    request.requestOperation.responseSerializer.acceptableContentTypes = request.responseAcceptableContentTypes;
    [self addOperation:request];
}

/**
 *  处理AFHttpRequestOperation获取的结果
 *
 *  @param operation AFHttpOperation
 *  @param error     错误
 */
- (void)handleRequestResult:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSString *key = [self requestHashKey:operation];
    CHTTPBaseRequest *request = _requestsRecord[key];
//    request.requestOperation = operation;
    if (request && !error) {
        CJSONLOG(@"请求成功 请求地址: %@", request.requestUrl);
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    }else{
        if (error  && error.code == -999) {
            CJSONLOG(@"用户取消请求");
            return;
        }
        CJSONLOG(@"请求失败 :%@",error? error.description : @"");
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (void)cancelRequest:(CHTTPBaseRequest *)request{
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)cancelRequestWithTag:(NSString *)tag{
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        CHTTPBaseRequest *request = copyRecord[key];
        if ([request.tag isEqualToString:tag]) {
            [request stop];
            break;
        }
    }
}

- (void)cancelAllRequests{
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        CHTTPBaseRequest *request = copyRecord[key];
        [request stop];//stop的时候就会移除掉request
        
    }
}

// 将requset记录下来
- (void)addOperation:(CHTTPBaseRequest *)request {
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation{
    NSString *key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
    CJSONLOG(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}
@end
