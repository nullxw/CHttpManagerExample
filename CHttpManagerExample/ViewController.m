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
@interface ViewController ()
{
    CHTTPRequest *_request;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _request = [[CHTTPRequest alloc] init];
    [_request setTag:@"test"];
    [_request setRequestUrl:@"http://www.yooomy.com/index.php/api/8da5388b9cc146ffd63ed9fa981db69b/guide.lists?city=185&range=1&keyword=&page=1"];
}
- (IBAction)startRequest:(id)sender {
    [_request startWithCompleteBlock:^(CHTTPBaseRequest *request) {
        CJSONLOG(@"this is success");
    } failBlock:^(CHTTPBaseRequest *request) {
        CJSONLOG(@"this is fail");
    }];
}

- (IBAction)stopRequest:(id)sender {
    [_request stop];
    //或者
//    [[CHTTPAgent sharedInstance] cancelRequest:_request];

}
- (IBAction)stopRequestWithTag:(id)sender {
    [[CHTTPAgent sharedInstance] cancelRequestWithTag:@"test"];
}

@end
