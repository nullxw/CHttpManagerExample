//
//  NSObject+Coding.m
//  CJSONMapperExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "NSObject+Coding.h"

@implementation NSObject (Coding)

#pragma mark - 实现NSCoding协议

- (void)encodeWithCoder:(NSCoder *)encoder {
    // Encode properties, other class variables, etc
    NSDictionary* propertyDict = [NSObject findAllpropertiesForClass:[self class]];
    
//    NSArray *skipProperties = nil;
//    
//    if ([self respondsToSelector:@selector(cjson_skipedProperty)]) {
//        skipProperties = [self performSelector:@selector(cjson_skipedProperty)];
//    }
//    
    for (NSString* key in propertyDict) {
//        if (!skipProperties || ![skipProperties containsObject:key]) {
            id value = [self valueForKey:key];
            [encoder encodeObject:value forKey:key];
//        }
    }
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if([self init]) {
        // Decode properties, other class vars
        NSDictionary* propertyDict = [NSObject findAllpropertiesForClass:[self class]];

        
//        NSArray *skipProperties = nil;
//        
//        if ([self respondsToSelector:@selector(cjson_skipedProperty)]) {
//            skipProperties = [self performSelector:@selector(cjson_skipedProperty)];
//        }
        
        for (NSString* key in propertyDict) {
//            if (!skipProperties || ![skipProperties containsObject:key]) {
                id value = [decoder decodeObjectForKey:key];
                [self setValue:value forKey:key];
//            }
        }
    }
    return self;
}


@end
