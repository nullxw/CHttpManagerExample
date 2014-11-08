//
//  CHTTPRequest.m
//  CHttpManagerExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPRequest.h"
#import "CHTTPConfig.h"

@implementation CHTTPRequest{
    BOOL _isDataFromCache;
    id _cacheObject;
}

#pragma mark - 重写父类的方法
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cacheVersion = [CHTTPConfig defaultCacheVersion];
    }
    return self;
}

- (void)start{
    //如果忽略缓存使用startWithCache
    
    //缓存版本是否过期
    if ([self isCacheVersionExpired]) {
        [super start];
        return;
    }
    
    //缓存时间是否缓存时间为0
    if (self.cacheTimeInSeconds == 0 ) {
        [super start];
        return;
    }
    
    //判断缓存是否存在
    if (![self isCacheExist]) {
        [super start];
        return;
    }
    
    //判断缓存时间是否过期
    if ([self isCacheExpired]) {
        [super start];
        return;
    }
    
    //使用缓存
    _isDataFromCache = YES;
    self.successCompletionBlock(self);
    [self clearCompletionBlock];
}

- (void)requestCompleteFilter{
    [self saveJsonResponseToCacheFile:[super responseJSONObject]];
}

- (void)requestFailFilter{
    
}

#pragma mark - 私有方法
- (void)startWithoutCache{
    [super start];
}

- (id)responseJSONObject{
    if (_cacheObject) {
        return _cacheObject;
    }else{
        return [super responseJSONObject];
    }
}

- (BOOL)isDataFromCache{
    return _isDataFromCache;
}


// 判断缓存版本是否过期
- (BOOL)isCacheVersionExpired{
    long long cacheVersionFileContent = [self cacheContetnVersion];
    if (cacheVersionFileContent != [self cacheVersion]) {
        return YES;
    } else {
        return NO;
    }
}

// 获取缓存中的版本
- (long long)cacheContetnVersion {
    return 0;
}

// 判断缓存时间是否过期
- (BOOL)isCacheExpired{
    return YES;
}

// 判断缓存是否存在
- (BOOL)isCacheExist{
    return NO;
}

#pragma mark - 将数据写入缓存中
- (void)saveJsonResponseToCacheFile:(id)jsonResponse{
    
}

@end
