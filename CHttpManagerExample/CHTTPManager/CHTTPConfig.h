//
//  CHTTPConfig.h
//  CHttpManagerExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHTTPConfig : NSObject


+ (NSString*)urlEncode:(NSString*)str;
+ (NSString *)md5StringFromString:(NSString *)string;
+ (NSString *)appVersionString;
+ (long long)defaultCacheVersion;
+ (NSString *)cachePrefix;
@end
