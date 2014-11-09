//
//  NSObject+Category.m
//  CJSONMapperExample
//
//  Created by outman on 14-11-8.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

#pragma mark - 类方法

/**
 *  获取自定义object的所有属性,以及对象的属性类型
 *
 *  @param cls 自定义对象的Class
 *
 *  @return property : propertyType 键值对
 */
+ (NSDictionary*)findAllpropertiesForClass:(Class)cls{
    
    if (cls == NULL) { //判断cls是否存在 ,不存在返回nil
        return nil;
    }
    
    //初始化results
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    //获取cls中所有的属性列表
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    //循环
    for (i = 0; i < outCount; i++) {
        //获取对应属性
        objc_property_t property = properties[i];
        //获取对应属性名
        const char *propName = property_getName(property);
        //判断属性名是否存在
        if(propName) {
            //获取属性对应的属性类型
            NSString *propType = [self getPropertyType:property];
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            //判断是否是系统属性
            if (![systemExcludedProperties containsObject:propertyName]) {
                results[propertyName] = propType;
            }
        }
    }
    
    //释放属性列表内存
    free(properties);
    
    // 搜索cls的superClass  直到NSObject为止
    if ([cls superclass] != [NSObject class]) {
        [results addEntriesFromDictionary:[self findAllpropertiesForClass:[cls superclass]]];
    }
    //返回已经查找到的键值对
    return [NSDictionary dictionaryWithDictionary:results];
}

/**
 *  获取属性的类型
 *
 *  @param property 需要获取类型的属性
 *
 *  @return 类型的字符串
 */
+ (NSString*)getPropertyType:(objc_property_t)property{
    
    //获取属性的所有attrs集合
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    
    strcpy(buffer, attributes);
    
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return name;
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return name;
        }
    }
    return @"id";//默认作为id类型
}


/**
 *  打印出对应cls的所有方法列表
 *
 *  @param cls
 */
+ (void)printAllMethodForClass:(Class)cls{
    
    if (cls == NULL) { //判断
        return;
    }
    
    unsigned int methodCount;
    //获取所有方法列表
    Method *methodList = class_copyMethodList(cls, &methodCount);
    unsigned int i = 0;
    for (; i < methodCount; i++) {
        NSLog(@"%@ 类中的方法- %@", [NSString stringWithCString:class_getName(cls) encoding:NSUTF8StringEncoding], [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding]);
    }
    
    //释放内存
    free(methodList);
    
    //循环父类
    if ([cls superclass] != [NSObject class]) {
        [NSObject printAllMethodForClass:[cls superclass]];
    }
    
}

@end
