//
//  CHTTPAgent.h
//  CHttpManagerExample
//
//  Created by wood-spring on 14-11-7.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHTTPBaseRequest.h"
@interface CHTTPAgent : NSObject


+ (CHTTPAgent *)sharedInstance;

- (void)addRequest:(CHTTPBaseRequest *)request;

- (void)cancelRequest:(CHTTPBaseRequest *)request;

- (void)cancelRequestWithTag:(NSString *)tag;

- (void)cancelAllRequests;


@end
