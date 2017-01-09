//
//  ViewController.m
//  ClientInAppDelegateObjC
//
//  Created by Jordan Zucker on 10/28/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

#import <PubNub/PubNub.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController () <PNObjectEventListener>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.client addListener:self];
    
    self.textView.editable = NO;
    self.textView.text = @"Loaded!\n";
    [self.textView setNeedsLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.textView.text = @"Cleared due to memory warning\n";
    [self.textView setNeedsLayout];
}

#pragma mark - PNObjectEventListener
//
//- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
//    NSString *statusString = [NSString stringWithFormat:@"%@\n", status.debugDescription];
//    self.textView.text = [statusString stringByAppendingString:self.textView.text];
//    [self.textView setNeedsLayout];
//}

- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
    if ((status.operation == PNHeartbeatOperation) && status.isError) {
        // We are going to react to any failed heartbeat operations here
        // By subscribing to an empty array of channels, we force the client
        // to re-establish its connection to PubNub, as a method to fight
        // issues with packet loss
        [client subscribeToChannels:@[] withPresence:YES];
    } else {
        // Do other status actions here
    }
}


- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    NSString *messageString = [NSString stringWithFormat:@"%@\n", message.debugDescription];
    self.textView.text = [messageString stringByAppendingString:self.textView.text];
    [self.textView setNeedsLayout];
}

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    NSString *presenceString = [NSString stringWithFormat:@"%@\n", event.debugDescription];
    self.textView.text = [presenceString stringByAppendingString:self.textView.text];
    [self.textView setNeedsLayout];
}


@end
