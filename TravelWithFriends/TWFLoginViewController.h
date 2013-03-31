//
//  TWFLoginViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/4/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class TWFSocialFriendDataController;
@class TWFLoginView;
@class TWFSocialFriendListViewController;
@class TWFSocialFriendListViewContainerViewController;

@interface TWFLoginViewController : UIViewController {
    TWFLoginView *_customView;
}

@property (retain, nonatomic) TWFSocialFriendDataController *socialFriendDataController;
@property (retain, nonatomic) TWFSocialFriendListViewController *socialFriendListViewController;
@property (retain, nonatomic) TWFSocialFriendListViewContainerViewController *friendListViewContainerController;

@end
