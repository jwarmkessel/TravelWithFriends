//
//  TWFSocialFriendListViewContainerViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/8/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWFSocialFriendDataController.h"
#import "TWFSocialFriendListViewController.h"

@interface TWFSocialFriendListViewContainerViewController : UIViewController

@property (strong, nonatomic) TWFSocialFriendDataController *socialFriendDataController;
@property (strong, nonatomic) TWFSocialFriendListViewController * socialFriendListViewController;

@end
