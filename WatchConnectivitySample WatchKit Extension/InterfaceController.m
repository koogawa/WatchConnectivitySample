//
//  InterfaceController.m
//  WatchConnectivitySample WatchKit Extension
//
//  Created by koogawa on 2015/07/04.
//  Copyright © 2015年 Kosuke Ogawa. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController() <WCSessionDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *resultLabel;
@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];

    // Configure interface objects here.
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    if ([[WCSession defaultSession] isReachable])
    {
        [[WCSession defaultSession] sendMessage:@{@"hoge":@"huga"}
                                   replyHandler:^(NSDictionary *replyHandler) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.resultLabel setText:[NSString stringWithFormat:@"replyHandler = %@", replyHandler]];
                                       });
                                   }
                                   errorHandler:^(NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.resultLabel setText:[NSString stringWithFormat:@"error = %@", error]];
                                       });
                                   }
         ];
    }

}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - WCSessionDelegate

- (void)sessionWatchStateDidChange:(WCSession *)session
{
    NSLog(@"%s: session = %@", __func__, session);
}

// Application Context
- (void)session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultLabel setText:[NSString stringWithFormat:@"%s: %@", __func__, applicationContext]];
    });
}

// User Info Transfer
- (void)session:(nonnull WCSession *)session didReceiveUserInfo:(nonnull NSDictionary<NSString *,id> *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultLabel setText:[NSString stringWithFormat:@"%s: %@", __func__, userInfo]];
    });
}

// File Transfer
- (void)session:(nonnull WCSession *)session didReceiveFile:(nonnull WCSessionFile *)file
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultLabel setText:[NSString stringWithFormat:@"%s: %@", __func__, file]];
    });
}

// Interactive Message
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultLabel setText:[NSString stringWithFormat:@"%s: %@", __func__, message]];
    });

    replyHandler(@{@"reply" : @"OK"});
}

@end
