//
//  TWFSocialFriendListViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/5/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWFFriendSearchDisplayController.h"

@interface TWFSocialFriendListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (copy, nonatomic) NSMutableArray *socialFriendList;
@property (strong, nonatomic) NSMutableArray *filteredFriendArray;
//@property (strong, nonatomic) TWFFriendSearchDisplayController *friendSearchDisplayController;
@property (strong, nonatomic) UISearchDisplayController * searchDisplayContr;

- (id)initWithFriendsList:(NSMutableArray *)socialFriendList;

@end
