//
//  TWFSocialFriendListViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/5/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWFSocialFriendListViewController : UITableViewController <UITableViewDelegate>

@property (copy, nonatomic) NSMutableArray *socialFriendList;

- (id)initWithFriendsList:(NSMutableArray *)socialFriendList;

@end
