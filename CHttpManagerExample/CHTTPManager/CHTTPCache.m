//
//  CHTTPCache.m
//  CHttpManagerExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CHTTPCache.h"
#import "CFileUtils.h"
#import "CHTTPConfig.h"

@implementation CHTTPCache{
    NSMutableDictionary *_dataCacheTimeDict; //cache save time
    NSMutableDictionary *_dataCacheVersionDict; //cache save version
}

+(CHTTPCache*)shareInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataCacheTimeDict = [NSMutableDictionary dictionary];
        _dataCacheVersionDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key{
    NSString *fullName = [[CFileUtils shareInstance] fullFileNameWithShortName:key filePathType:CCachePath];
    if ([[CFileUtils shareInstance] isFileExistWithFileName:key filePathType:CCachePath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:fullName];
    }else{
        return nil;
    }
}

- (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key{
    NSString *fullFileName = [[CFileUtils shareInstance] fullFileNameWithShortName:key filePathType:CCachePath];
    if ([[CFileUtils shareInstance] isFileExistWithFileName:key filePathType:CCachePath]) {
        NSLog(@"file existed");
        return;
    }
    [NSKeyedArchiver archiveRootObject:object toFile:fullFileName];
    [_dataCacheTimeDict setObject:@([[NSDate date] timeIntervalSince1970]) forKey:key];
}

- (void)setCacheVersion:(long long)cacheVersion forKey:(NSString *)key{
    [_dataCacheVersionDict setObject:@(cacheVersion) forKey:key];
}

- (void)deleteObjectForKey:(NSString *)key{
    [_dataCacheTimeDict removeObjectForKey:key];
    [_dataCacheVersionDict removeObjectForKey:key];
    [[CFileUtils shareInstance] deleteFileWithFileName:key filePathType:CCachePath];
}

- (void)cleanDiskCache{
    NSArray *files = [[CFileUtils shareInstance] filesAtPath:nil filePathType:CCachePath];
    for (NSString *fileName in files) {
        if ([fileName hasPrefix:[CHTTPConfig cachePrefix]]) {
            [self deleteObjectForKey:fileName];
        }
    }
}

- (NSTimeInterval)objectCacheTimeForKey:(NSString *)key{
    if ([_dataCacheTimeDict objectForKey:key]) {
        return [[_dataCacheTimeDict objectForKey:key] longLongValue];
    }
    return 0;
}

- (long long)objectCacheVersionForKey:(NSString *)key{
    if ([_dataCacheVersionDict objectForKey:key]) {
        return [[_dataCacheVersionDict objectForKey:key] longLongValue];
    }
    return 1;
}

- (BOOL)isCacheVerionExpiredForKey:(NSString *)key cacheVersion:(long long)cacheVersion{
    long long nowVersion = [self objectCacheVersionForKey:key];
    if (nowVersion == cacheVersion) {
        return NO;
    }
    [self deleteObjectForKey:key];
    return YES;
}

- (BOOL)isCacheTimeExpiredForKey:(NSString *)key cacheSeconds:(NSTimeInterval)seconds{
    NSTimeInterval cacheTime = [self objectCacheTimeForKey:key];
    NSTimeInterval nowTime = (unsigned long long)[[NSDate date] timeIntervalSince1970];
    if (cacheTime + seconds > nowTime) {
        return NO;
    }
    [self deleteObjectForKey:key];
    return YES;
}
@end
