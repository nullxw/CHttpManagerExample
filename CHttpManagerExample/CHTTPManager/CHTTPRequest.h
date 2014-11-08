//
//  CHTTPRequest.h
//  CHttpManagerExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPBaseRequest.h"

@interface CHTTPRequest : CHTTPBaseRequest

//是否忽略缓存
@property (nonatomic) BOOL ignoreCache;
@property (nonatomic) NSInteger cacheTimeInSeconds;
@property (nonatomic) long long cacheVersion;

// 是否当前的数据从缓存获得
- (BOOL)isDataFromCache;

// 返回是否当前缓存需要更新
- (BOOL)isCacheVersionExpired;

// 强制更新缓存
- (void)startWithoutCache;

// 手动将其他请求的JsonResponse写入该请求的缓存
- (void)saveJsonResponseToCacheFile:(id)jsonResponse;

@end
