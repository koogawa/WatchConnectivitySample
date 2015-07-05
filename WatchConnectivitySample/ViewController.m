//
//  ViewController.m
//  WatchConnectivitySample
//
//  Created by koogawa on 2015/07/04.
//  Copyright © 2015年 Kosuke Ogawa. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController () <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (strong, nonatomic) NSDictionary *applicationDict;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.applicationDict = @{@"hoge" : @"huga"};

    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applicationContextButtonTapped:(id)sender
{
    // Application Context
    NSError *error = nil;
    [[WCSession defaultSession] updateApplicationContext:self.applicationDict
                                                   error:&error];
    NSLog(@"error = %@", error);
}

- (IBAction)userInfoTransferButtonTapped:(id)sender
{
    // User Info Transfer
    [[WCSession defaultSession] transferUserInfo:self.applicationDict];

}

- (IBAction)fileTransferButtonTapped:(id)sender
{
    // File Transfer
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"marimo" ofType:@"png"]];
    WCSessionFileTransfer *fileTransfer = [[WCSession defaultSession] transferFile:url
                                                                          metadata:self.applicationDict];
    NSLog(@"fileTransfer = %@", fileTransfer);
}

- (IBAction)interactiveMessageButtonTapped:(id)sender
{
    // Interactive Message
    if ([[WCSession defaultSession] isReachable])
    {
        [[WCSession defaultSession] sendMessage:self.applicationDict
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

#pragma mark - WCSessionDelegate

// Interactive Message
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultTextView.text = [NSString stringWithFormat:@"%s: %@", __func__, message];
    });

    replyHandler(@{@"reply" : @"OK"});
}

@end
