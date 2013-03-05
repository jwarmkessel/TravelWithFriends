//
//  TWFAppDelegate.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/2/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SFSocialFacebook.h>

@class TWFMainViewController;

@interface TWFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TWFMainViewController *mainViewController;
@property (strong, atomic) SFSocialFacebook *socialFacebook;
@end
