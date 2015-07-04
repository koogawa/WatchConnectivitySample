//
//  ViewController.m
//  WatchConnectivitySample
//
//  Created by koogawa on 2015/07/04.
//  Copyright © 2015年 Kosuke Ogawa. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Application Context
    NSDictionary *applicationDict = @{@"hoge" : @"huga"};
    NSError *error = nil;
    [[WCSession defaultSession] updateApplicationContext:applicationDict error:&error];
    NSLog(@"error = %@", error);

    // User Info Transfer
    [[WCSession defaultSession] transferUserInfo:applicationDict];

    // File Transfer
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"marimo" ofType:@"png"]];
    WCSessionFileTransfer *fileTransfer = [[WCSession defaultSession] transferFile:url metadata:applicationDict];
    NSLog(@"fileTransfer = %@", fileTransfer);

    // Interactive Message
    if ([[WCSession defaultSession] isReachable])
    {
        [[WCSession defaultSession] sendMessage:applicationDict
                                   replyHandler:^(NSDictionary *replyHandler) {
                                       NSLog(@"replyHandler = %@", replyHandler);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.resultTextView.text = [NSString stringWithFormat:@"%@", replyHandler];
                                       });
                                   }
                                   errorHandler:^(NSError *error) {
                                       NSLog(@"error = %@", error);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.resultTextView.text = [NSString stringWithFormat:@"%@", error];
                                       });
                                   }
         ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
