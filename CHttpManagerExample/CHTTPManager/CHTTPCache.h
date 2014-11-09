//
//  CHTTPCache.h
//  CHttpManagerExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFileUtils.h"
@interface CHTTPCache : NSObject


+(CHTTPCache*)shareInstance;

- (id)objectForKey:(NSString *)key;

- (BOOL)isCacheVerionExpiredForKey:(NSString *)key cacheVersion:(long long)cacheVersion;

- (BOOL)isCacheTimeExpiredForKey:(NSString *)key cacheSeconds:(NSTimeInterval)seconds;

- (void)cacheObject:(id<NSCoding>)object forKey:(NSString*)key;

- (void)setCacheVersion:(long long)cacheVersion forKey:(NSString *)key;

- (void)deleteObjectForKey:(NSString *)key;

- (void)cleanDiskCache;
@end
