//
//  TWFSocialFriendDetailViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/9/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWFSocialFriend;

@interface TWFSocialFriendDetailViewController : UIViewController

@property (strong, nonatomic) UIImageView *profilePictureImageView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *firstNameLabel;
@property (strong, nonatomic) UILabel *lastNameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *currentPositionLabel;

@property (strong, nonatomic) UIButton *startCaravanBtn;
@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) TWFSocialFriend *friend;

- (id)initWithFriend:(TWFSocialFriend *)friend;

@end