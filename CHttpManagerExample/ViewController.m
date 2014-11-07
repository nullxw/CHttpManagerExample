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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CHTTPBaseRequest *request = [[CHTTPBaseRequest alloc] init];
    [request setTag:@"test"];
    [request setRequestUrl:@"http://www.yooomy.com/index.php/api/8da5388b9cc146ffd63ed9fa981db69b/guide.lists?city=185&range=1&keyword=&page=1"];
    [request startWithCompleteBlock:^(CHTTPBaseRequest *request) {
        CJSONLOG(@"this is success");
    } failBlock:^(CHTTPBaseRequest *request) {
        CJSONLOG(@"this is fail");
    }];
    [[CHTTPAgent sharedInstance] cancelRequestWithTag:@"test"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
