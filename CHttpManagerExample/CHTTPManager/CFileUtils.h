//
//  CFileUtils.h
//  CHttpManagerExample
//
//  Created by outman on 14-11-9.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CFilePathType) {
    CDoumentsPath = 0,
    CCachePath
};

@interface CFileUtils : NSObject

@property (nonatomic,copy) NSString *dirName;

+ (CFileUtils*)shareInstance;

- (NSString *)fullFileNameWithShortName:(NSString *)shortName filePathType:(CFilePathType)filePath;

- (BOOL)isFileExistWithFileName:(NSString *)shortName filePathType:(CFilePathType)filePath;

- (BOOL)deleteFileWithFileName:(NSString *)shortName filePathType:(CFilePathType)filePath;

- (NSArray *)filesAtPath:(NSString *)path filePathType:(CFilePathType)filePath;

@end
