//
//  CHTTPBaseRequest.h
//  CHttpManagerExample
//
//  Created by wood-spring on 14-11-7.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#ifdef DEBUG
#   define CJSONLOG(__FORMAT__, ...) NSLog(__FORMAT__, ##__VA_ARGS__)
#else
#   define CJSONLOG(...)
#endif

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"

typedef NS_ENUM(NSInteger , CHTTPRequestMethod) {
    CHTTPRequestMethodGet = 0,
    CHTTPRequestMethodPost,
    CHTTPRequestMethodHead,
    CHTTPRequestMethodPut,
    CHTTPRequestMethodDelete,
};

typedef NS_ENUM(NSInteger , CHTTPRequestSerializerType) {
    CHTTPRequestSerializerTypeHTTP = 0,
    CHTTPRequestSerializerTypeJSON,
};

typedef void(^CHTTPConstructionBodyBlock)(id<AFMultipartFormData> formData);
typedef void (^CHTTPDownloadProgressBlock)(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);

@class CHTTPBaseRequest;
typedef void (^CHTTPSuccessBlock)(CHTTPBaseRequest *request);
typedef void (^CHTTPFailBlock)(CHTTPBaseRequest *request);

//声明协议,主要用于处理提示等处理
@protocol CHTTPRequestAccessory <NSObject>

@optional
- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end


@interface CHTTPBaseRequest : NSObject


#pragma mark - 请求相关参数

// 请求的tag
@property (nonatomic, copy) NSString *tag;

// 请求携带的用户信息
@property (nonatomic, strong) NSDictionary *userInfo;

//正式的请求
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

// 请求地址
@property (nonatomic, copy) NSString *requestUrl;

// 请求参数列表 最好用NSDictionary
@property (nonatomic, strong) id requestArguments;

// 请求认证相关参数
@property (nonatomic, strong) NSDictionary *requestAuthorizationDictionary;

// 请求的方法类型
@property (nonatomic,assign) CHTTPRequestMethod requestMethod;

// 请求头部类型,仅用于AFNetwork 因为其有AFHTTP,AFJSON两种类型
@property (nonatomic,assign) CHTTPRequestMethod requestSerializerType;

// 多文件上传时block
@property (nonatomic,copy) CHTTPConstructionBodyBlock constructingBodyBlock;

// 自定义的请求方法,不需要可以不处理,主要用于配置自定义超时的
@property (nonatomic, strong) NSURLRequest *customRequest;

// 请求返回类型 可接受的类型 "text/html"等
@property (nonatomic, strong) NSSet *responseAcceptableContentTypes;

// 存放request状态监控的代理 处理请求willStart didStop  未使用
@property (nonatomic, strong) NSMutableArray *requestAccessories;

#pragma mark - 下载文件相关请求参数

// 请求下载文件存储地址
@property (nonatomic, copy) NSString *requestDownloadPath;

// 是否继续下载
@property (nonatomic) BOOL shouldResume;

// 下载文件是进度block
@property (nonatomic,copy) CHTTPDownloadProgressBlock downloadProgressBlock;


#pragma mark - 请求开始,取消方法
// 开始一个请求
- (void)start;

// 取消请求,移除队列
- (void)stop;

- (void)startWithCompleteBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failedBlock;

//移除block 防止循环引用
- (void)clearCompletionBlock;

- (NSString *)completeRequestUrl;

- (void)toggleRequestWillStart;
- (void)toggleRequestWillStop;
- (void)toggleRequestDidStop;

#pragma mark - 请求完成后处理,需要子类重写,用来请求完成后缓存
- (void)requestCompleteFilter;
- (void)requestFailFilter;


#pragma mark - 请求返回的结果

//返回response的头部信息
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

//response的字符串形式
@property (nonatomic, strong, readonly) NSString *responseString;

//response的JSONObject
@property (nonatomic, strong, readonly) id responseJSONObject;

//请求的返回结果 404,500等
@property (nonatomic, assign,readonly) NSInteger responseStatusCode;

//请求成功block
@property (nonatomic, copy) CHTTPSuccessBlock successBlock;

//请求失败Block
@property (nonatomic, copy) CHTTPFailBlock failBlock;

//判断请求是否正在执行
@property (nonatomic, assign, readonly) BOOL isExecuting;

@end
