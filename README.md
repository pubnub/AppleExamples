# AppleExamples

Each project in this repository represents a good coding practice for PubNub.

To run the example projects, clone the repo, and run `pod install` from the root directory of the repository first.

The projects are divided into two major directories, one for [Swift](https://github.com/pubnub/AppleExamples/tree/master/Swift) and one for [Objective-C](https://github.com/pubnub/AppleExamples/tree/master/Objective-C). Each example project has a version in each language's directory.

### ClientInAppDelegate
Shows how to properly create and use PubNub in the AppDelegate of an iOS app and encourages unsubscribing instead of deallocating the client instance.

Take note of how the client instance from the AppDelegate is accessed from a UIViewController

### ClientAsSingleton
Shows how to properly create and use PubNub as a singleton within an iOS app and how to call that singleton from a UIViewController.

### PushNotifications
Shows how to properly use APNS on only iOS 10 with PubNub. If you want to use push notifications and target iOS 8 through 10, then see OldPushNotifications

### OldPushNotifications
Shows how to properly use push notifications on iOS 8 through 10 with PubNub.

## Author

Jordan Zucker, jordan.zucker@gmail.com

## License

AppleExamples is available under the MIT license. See the LICENSE file for more info.

## To Do

- [ ] Add extension examples
- [ ] Add macOS examples