//
//  AppDelegate.m
//  MapboxObjC
//
//  Created by Jordan Zucker on 11/16/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

#import <PubNub/PubNub.h>
#import "AppDelegate.h"

NSString * const kPublishKey = @"demo";
NSString * const kSubscribeKey = @"demo";

@interface AppDelegate () <PNObjectEventListener>
@property (strong, nonatomic, readwrite) PubNub *client;
@end

@implementation AppDelegate

- (PubNub *)client {
    if (!_client) {
        // insert your keys here
        PNConfiguration *config = [PNConfiguration configurationWithPublishKey:kPublishKey subscribeKey:kSubscribeKey];
        _client = [PubNub clientWithConfiguration:config];
        // optionally add the app delegate as a listener, or anything else
        // View Controllers should get the client from the App Delegate
        // and add themselves as listeners if they are interested in
        // stream events (subscribe, presence, status)
        [_client addListener:self];
    }
    return _client;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // This is where you should register for push notifications and
    // add any push tokens using your client
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // This is where you should unsubscribe
    [self.client unsubscribeFromAll];
    // optionally add any push notification channels here
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // This is the best place to begin resubscribing to any important channels
    NSArray<NSString *> *channels = @[
                                      @"a",
                                      ];
    [self.client subscribeToChannels:channels withPresence:YES];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
