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

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) TWFMainViewController *mainViewController;
@property (retain, atomic) SFSocialFacebook *socialFacebook;

@end
