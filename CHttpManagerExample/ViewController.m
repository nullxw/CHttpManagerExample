//
//  ViewController.m
//  CHttpManagerExample
//
//  Created by wood-spring on 14-11-7.
//  Copyright (c) 2014年 wood-spring. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CHTTPAgent.h"
#import "CHTTPCache.h"
#import "CHTTPManager.h"

@interface ViewController ()
{
    CHTTPRequest *_request;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startRequest:(id)sender {
    
     _request = [CHTTPManager chttp_getWithUrl:@"http://www.yooomy.com/index.php/api/8da5388b9cc146ffd63ed9fa981db69b/guide.lists?city=185&range=1&keyword=&page=1" cahceSeconds:30 successBlock:^(CHTTPBaseRequest *request) {
         CJSONLOG(@"this is success");
         NSLog(@"this is request respionse %@",request.responseJSONObject);
         NSLog(@"this is data From Cache %d",[(CHTTPRequest*)request isDataFromCache]);
    } failBlock:^(CHTTPBaseRequest *request) {
        CJSONLOG(@"this is fail");
    }];
    
}

- (IBAction)stopRequest:(id)sender {
    //或者
    [[CHTTPAgent sharedInstance] cancelRequest:_request];

}
- (IBAction)stopRequestWithTag:(id)sender {
    //you can send a request with test then cancel it
//    [[CHTTPAgent sharedInstance] cancelRequestWithTag:@"test"];
}

@end
