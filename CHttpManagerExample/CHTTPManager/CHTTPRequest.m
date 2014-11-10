//
//  CHTTPRequest.m
//  CHttpManagerExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPRequest.h"
#import "CHTTPConfig.h"
#import "CHTTPCache.h"

@implementation CHTTPRequest{
    BOOL _isDataFromCache;
    id _cacheObject;
}

#pragma mark - 重写父类的方法
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cacheVersion = [CHTTPConfig defaultCacheVersion];
        self.cacheTimeInSeconds = 0;
    }
    return self;
}

- (void)start{
    //如果忽略缓存使用startWithCache
    
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
    
    //缓存版本是否过期
    if ([self isCacheVersionExpired]) {
        [super start];
        return;
    }

    
    //判断缓存时间是否过期
    if ([self isCacheExpired]) {
        [super start];
        return;
    }
    
    _cacheObject = [[CHTTPCache shareInstance] objectForKey:self.cacheKey];
    if (!_cacheObject){
        [super start];
        return;
    }
    
    //使用缓存
    _isDataFromCache = YES;
    self.successBlock(self);
    [self clearCompletionBlock];
}

- (void)requestCompleteFilter{
    [self saveJsonResponseToCacheFile:[super responseJSONObject]];
}

- (void)requestFailFilter{
    
}

#pragma mark - 私有方法列表
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

- (NSString *)cacheKey{
    return [[CHTTPConfig cachePrefix] stringByAppendingString:[CHTTPConfig md5StringFromString:self.completeRequestUrl]];
}

// 判断缓存版本是否过期
- (BOOL)isCacheVersionExpired{
    return [[CHTTPCache shareInstance] isCacheVerionExpiredForKey:self.cacheKey cacheVersion:self.cacheVersion];
}

// 判断缓存时间是否过期
- (BOOL)isCacheExpired{
    return [[CHTTPCache shareInstance] isCacheTimeExpiredForKey:self.cacheKey cacheSeconds:self.cacheTimeInSeconds];
}

// 判断缓存是否存在
- (BOOL)isCacheExist{
    return [[CFileUtils shareInstance] isFileExistWithFileName:self.cacheKey filePathType:CCachePath];
}

#pragma mark - 将数据写入缓存中
- (void)saveJsonResponseToCacheFile:(id)jsonResponse{
    [[CHTTPCache shareInstance] cacheObject:jsonResponse forKey:self.cacheKey];
    [[CHTTPCache shareInstance] setCacheVersion:self.cacheVersion forKey:self.cacheKey];
}

@end
