//
//  AppDelegate.m
//  PushNotificationsObjC
//
//  Created by Jordan Zucker on 10/28/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

#import <PubNub/PubNub.h>
#import "AppDelegate.h"
@import UserNotifications;

NSString * const kPushNotificationTokenKey = @"PushNotificationTokenKey";
NSString * const kPublishKey = @"pub-c-a55c6b03-0ee0-4d49-8add-fec72f9d0921";
NSString * const kSubscribeKey = @"sub-c-e230ac82-9d56-11e6-8eb2-02ee2ddab7fe";

@interface AppDelegate () <PNObjectEventListener>
@property (strong, nonatomic, readwrite) PubNub *client;
@property (strong, nonatomic, readwrite) NSData *pushDeviceToken;
@end

@implementation AppDelegate
@synthesize pushDeviceToken = _pushDeviceToken;

- (NSData *)pushDeviceToken {
    if (!_pushDeviceToken) {
        _pushDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kPushNotificationTokenKey];
    }
    return _pushDeviceToken;
}

- (void)setPushDeviceToken:(NSData *)pushDeviceToken {
    // First we want to remove the old device push token if it is non nil
    // It is important to make a copy because we are about to replace the value
    // And we want to make sure if there is a retry it does not retry with the
    // newly replaced value
    NSData *oldTokenCopy = self.pushDeviceToken.copy;
    if (oldTokenCopy) {
        [self.client removeAllPushNotificationsFromDeviceWithPushToken:oldTokenCopy andCompletion:^(PNAcknowledgmentStatus * _Nonnull status) {
            // Confirm the push token was removed
        }];
    }
    _pushDeviceToken = pushDeviceToken;
    // Here is where we store the push device token for future use
    [[NSUserDefaults standardUserDefaults] setObject:_pushDeviceToken forKey:kPushNotificationTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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
    // Check Notification Settings on launch
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            // This means we have not yet asked for notification permissions
            case UNAuthorizationStatusNotDetermined:
            {
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    // You might want to remove this, or handle errors differently in production
                    NSAssert(error == nil, @"There should be no error");
                    if (granted) {
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    }
                }];
            }
                break;
            // We are already authorized, so no need to ask
            case UNAuthorizationStatusAuthorized:
            {
                // Just try and register for remote notifications
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
                break;
            // We are denied User Notifications
            case UNAuthorizationStatusDenied:
            {
                // Possibly display something to the user
                UIAlertController *useNotificationsController = [UIAlertController alertControllerWithTitle:@"Turn on notifications" message:@"This app needs notifications turned on for the best user experience" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Go to settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
                [useNotificationsController addAction:goToSettingsAction];
                [useNotificationsController addAction:cancelAction];
                [self.window.rootViewController presentViewController:useNotificationsController animated:true completion:nil];
                NSLog(@"We cannot use notifications because the user has denied permissions");
            }
                break;
        }
        
    }];
    
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

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken: %@", deviceToken);
    self.pushDeviceToken = deviceToken;
    if (self.pushDeviceToken) {
        // Add any push tokens to channels on app did finish launching
        NSArray<NSString *> *pushChannels = @[@"a"];
        // As a bonus, since we have cached the push token above,
        // if you add channels elsewhere that you would also like
        // to receive pushes on, then use the `pushDeviceToken`
        // property from the App Delegate to add push tokens then as well
        [self.client addPushNotificationsOnChannels:pushChannels withDevicePushToken:self.pushDeviceToken andCompletion:^(PNAcknowledgmentStatus * _Nonnull status) {
            // Confirm push token addition
        }];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Handle error here (most likely a failed certificate or an
    // invalid network connection
}

#pragma mark - Memory Warning

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // This is called when there is memory pressure, as expected
    // It is a good to release our reference to our PubNub client if
    // it is not subscribing, since it is needed then, and will be
    // created again if it is needed.
    // Note: Only release it if it is not subscribing, otherwise this
    // will most likely negatively impact user experience
    if (
        (self.client.channels.count == 0) &&
        (self.client.channelGroups.count == 0) &&
        (self.client.presenceChannels.count == 0)
        ){
        self.client = nil;
    }
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
    // This is a good place to deal with unexpected status messages like
    // network failures
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    // This most likely won't be used here, but in any relevant view controllers
    NSLog(@"message: %@", message.data.message);
}

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    // This most likely won't be used here, but in any relevant view controllers
}


@end
