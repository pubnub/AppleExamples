//
//  MyPubNubClient.m
//  ClientAsSingletonObjC
//
//  Created by Jordan Zucker on 11/15/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

#import "MyPubNubClient.h"

NSString * const kPublishKey = @"demo";
NSString * const kSubscribeKey = @"demo";

@interface MyPubNubClient () <PNObjectEventListener>
@end

@implementation MyPubNubClient

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        PNConfiguration *config = [PNConfiguration configurationWithPublishKey:kPublishKey subscribeKey:kSubscribeKey];
        sharedInstance = [self clientWithConfiguration:config];
        [sharedInstance addListener:sharedInstance]; // This is so we can handle status updates below
    });
    return sharedInstance;
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
    // This is a good place to deal with unexpected status messages like
    // network failures
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    // This most likely won't be used here, but in any relevant view controllers
}

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    // This most likely won't be used here, but in any relevant view controllers
}

@end
