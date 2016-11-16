//
//  MyPubNubClient.h
//  ClientAsSingletonObjC
//
//  Created by Jordan Zucker on 11/15/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

#import <PubNub/PubNub.h>

@interface MyPubNubClient : PubNub

+ (instancetype)sharedClient;

@end
