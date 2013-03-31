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

@property (retain, nonatomic) TWFSocialFriendListViewController *socialFriendListViewController;
@property (retain, nonatomic) NSMutableArray *socialFriendList;
- (id)initWithFriendList:(NSMutableArray *)array;
@end
