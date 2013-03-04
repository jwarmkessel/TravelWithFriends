SFSocialFacebook
================

This is a Facebook SDK Façade for iOS with Blocks. SFSocialFacebook is a fork of [Facebook SDK for iOS](https://github.com/facebook/facebook-ios-sdk) with simpler and cleaner way to use.

Installation
------------

### CocoaPod

    dependency 'SFSocialFacebook',  '~>1.2'

### Non-CocoaPod

Copy all files from `src/` except `.xcodeproj`and `.pch` files to your project.

Setup
-----

Configure the `URL Scheme` in your project's `Info.plist` as the image below:

![Info.plist setup](http://indigotech.github.com/facebook-ios-sdk/images/info-plist-config.png)

And your project's `AppDelegate.m`:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSArray *permissions = [[NSArray alloc] initWithObjects:@"create_event", @"user_events", @"rsvp_event", @"publish_stream", nil];
  _socialFacebook = [SFSocialFacebook sharedInstanceWithAppId:@"YOUR_APP_ID" appSecret:@"YOUR_APP_SECRET" urlSchemeSuffix:nil andPermissions:permissions];
  [permissions release];
  ...
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [_socialFacebook handleOpenURL:url];
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [_socialFacebook handleOpenURL:url];
}
```

Usage Example
-------------

Publish example:

```objective-c
SFSimplePost *post = [[SFSimplePost alloc] init];
    post.name = @"I'm using the I.ndigo Test App for iOS app";
    post.caption = @"I.ndigo Test App for iOS.";
    post.postDescription = @"Check out I.ndigo Test App for iOS to learn how you can make your iOS apps social using Facebook Platform.";
    post.link = @"http://www.i.ndigo.com.br/";
    post.picture = @"https://fbcdn-photos-a.akamaihd.net/photos-ak-snc1/v85006/197/198801296855729/app_1_198801296855729_3543.gif";
    post.actionName = @"I.ndigo Website";
    post.actionLink = @"http://i.ndigo.com.br";
    post.message = @"Message created by App";

[[SFSocialFacebook sharedInstance] publishPost:post success:^(NSString *postId) {
    // Success callback
} failure:^(NSError *error) {
    // Error callback
} cancel:^{
    // Cancel callback
}];

[post release];
```

Feed example:

```objective-c
[[SFSocialFacebook sharedInstance] profileFeed:_profileId 
                                      pageSize:5 
                                    needsLogin:_needsLogin
                                       success:^(NSArray *posts, NSString *nextPageUrl) {
                                         // Success callback
                                       }
                                       failure:^(NSError *error) {
                                         // Error callback
                                       }
                                       cancel:^{
                                         // Cancel callback
                                       }];
```

Sample Application
------------------

There is a sample XCode project using SFSocialFacebook in `sample/SFSocialFacebookExample/SFSocialFacebookExample.xcodeproj`.

License
-------

SFSocialFacebook is licensed under the Apache License, Version 2.0.

Copyright 2012 I.ndigo

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.