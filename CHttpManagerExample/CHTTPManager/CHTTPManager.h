//
//  CHTTPManager.h
//  CHttpManagerExample
//
//  Created by outman on 14-11-9.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHTTPAgent.h"

@interface CHTTPManager : NSObject

+ (CHTTPManager *)manager;

@property (nonatomic,copy) NSString *baseUrl;

+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;
+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url tag:(NSString*)tag successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;
+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url cahceSeconds:(NSInteger)seconds successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;
+ (CHTTPRequest *)chttp_getWithUrl:(NSString *)url cahceSeconds:(NSInteger)seconds tag:(NSString*)tag successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;



+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url arguments:(id)arguments successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;
+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url tag:(NSString*)tag arguments:(id)arguments successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;
+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url arguments:(id)arguments cacheSeconds:(NSInteger)seconds successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;
+ (CHTTPRequest *)chttp_postWithUrl:(NSString *)url arguments:(id)arguments cacheSeconds:(NSInteger)seconds tag:(NSString*)tag successBlock:(CHTTPSuccessBlock)successBlock failBlock:(CHTTPFailBlock)failBlock;

@end
