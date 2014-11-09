//
//  NSObject+Category.h
//  CJSONMapperExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define systemExcludedProperties @[@"observationInfo",@"hash",@"description",@"debugDescription",@"superclass"]


@interface NSObject (Category)

#pragma mark - 类方法
+ (NSDictionary*)findAllpropertiesForClass:(Class)cls;
+ (NSString*)getPropertyType:(objc_property_t)property;
+ (void)printAllMethodForClass:(Class)cls;

@end
