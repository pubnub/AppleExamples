//
//  AppDelegate.h
//  PushNotificationsObjC
//
//  Created by Jordan Zucker on 10/28/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PubNub;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) PubNub *client;

@property (nonatomic, strong, readonly) NSData *pushDeviceToken;


@end

