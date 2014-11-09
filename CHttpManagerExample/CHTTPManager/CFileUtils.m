//
//  CFileUtils.m
//  CHttpManagerExample
//
//  Created by outman on 14-11-9.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "CFileUtils.h"
#import "CHTTPConfig.h"

#ifdef DEBUG
#   define CLOG(__FORMAT__, ...) NSLog(__FORMAT__, ##__VA_ARGS__)
#else
#   define CLOG(...)
#endif


@implementation CFileUtils

+(CFileUtils*)shareInstance{
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
        
    }
    return self;
}

- (NSString *)documentDirectory{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    return documentDirectory;
}

- (NSString *)cacheDirectory{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [directoryPaths objectAtIndex:0];
    return cacheDirectory;
}

- (NSString *)fullFileNameWithShortName:(NSString *)shortName filePathType:(CFilePathType)filePath{
    NSString *fullPath = nil;
    if (filePath == CDoumentsPath) {
        fullPath = [self documentDirectory];
    }else{
        fullPath = [self cacheDirectory];
    }
    if (shortName) {
        return [fullPath stringByAppendingPathComponent:shortName];
    }else{
        return fullPath;
    }
}

- (BOOL)isFileExistWithFileName:(NSString *)shortName filePathType:(CFilePathType)filePath{
    NSString *fullFileName = [self fullFileNameWithShortName:shortName filePathType:filePath];
    return [[NSFileManager defaultManager] fileExistsAtPath:fullFileName];
}

- (NSArray *)filesAtPath:(NSString *)path filePathType:(CFilePathType)filePath{
    NSString *fullPath = [self fullFileNameWithShortName:path filePathType:filePath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
    return files;
}

- (BOOL)deleteFileWithFileName:(NSString *)shortName filePathType:(CFilePathType)filePath{
    if (![self isFileExistWithFileName:shortName filePathType:filePath]) {
        CLOG(@"file : %@ not exist",shortName);
        return YES;
    }
    NSError *error = nil;
    NSString *fullFileName = [self fullFileNameWithShortName:shortName filePathType:filePath];
    CLOG(@"this is full :%@",fullFileName);
    [[NSFileManager defaultManager] removeItemAtPath:fullFileName error:&error];
    if (error) {
        CLOG(@"file : %@ remove fail,%@",shortName,[error localizedDescription]);
        return NO;
    }
    CLOG(@"remove file success");
    return YES;
}


@end
