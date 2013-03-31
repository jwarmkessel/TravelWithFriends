//
//  TWFSocialFriendDetailViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/9/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWFSocialFriend;
@class TWFSocialFriendDetailView;
@interface TWFSocialFriendDetailViewController : UIViewController {
    TWFSocialFriendDetailView * _socialFriendDetailView;
}

@property (retain, nonatomic) UIImageView *profilePictureImageView;

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *firstNameLabel;
@property (retain, nonatomic) UILabel *lastNameLabel;
@property (retain, nonatomic) UILabel *statusLabel;
@property (retain, nonatomic) UILabel *currentPositionLabel;

@property (retain, nonatomic) UIButton *startCaravanBtn;
@property (retain, nonatomic) UIButton *cancelBtn;

@property (retain, nonatomic) TWFSocialFriend *friend;

- (id)initWithFriend:(TWFSocialFriend *)friend;

@end