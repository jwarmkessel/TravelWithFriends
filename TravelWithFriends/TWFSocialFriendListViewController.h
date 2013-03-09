//
//  TWFSocialFriendListViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/5/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWFFriendSearchDisplayController.h"

@interface TWFSocialFriendListViewController : UITableViewController <UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (copy, nonatomic) NSMutableArray *socialFriendList;
@property (strong, nonatomic) TWFFriendSearchDisplayController *friendSearchDisplayController;

- (id)initWithFriendsList:(NSMutableArray *)socialFriendList;

@end
