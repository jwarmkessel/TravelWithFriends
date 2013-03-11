//
//  TWFSocialFriendDetailViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/9/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriendDetailViewController.h"
#import "TWFSocialFriendDetailView.h"
#import "TWFSocialFriend.h"
#import <QuartzCore/QuartzCore.h>

@interface TWFSocialFriendDetailViewController ()

@end

@implementation TWFSocialFriendDetailViewController
@synthesize friend = _friend;

- (id)initWithFriend:(TWFSocialFriend *)friend {
    if (self) {
        _friend = friend;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TWFSocialFriendDetailView *socialFriendDetailView = [[TWFSocialFriendDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:socialFriendDetailView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    self.titleLabel.text = @"Location Sync With";
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    
    self.profilePictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 75.0f, 75.0f)];
    
    self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 44.0f, 320.0f, 44.0f)];
    self.firstNameLabel.text = self.friend.firstName;
    [self.firstNameLabel setBackgroundColor:[UIColor clearColor]];
    
    self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 88.0f, 320.0f, 44.0f)];
    self.lastNameLabel.text = self.friend.lastName;
    [self.lastNameLabel setBackgroundColor:[UIColor clearColor]];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 132.0f, 320.0f, 44.0f)];
    self.statusLabel.text = @"Status: ";
    [self.statusLabel setBackgroundColor:[UIColor clearColor]];
    
    self.currentPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 176.0f, 320.0f, 44.0f)];
    self.currentPositionLabel.text = @"Current: ";
    [self.currentPositionLabel setBackgroundColor:[UIColor clearColor]];
    
    [socialFriendDetailView addSubview:self.titleLabel];
    [socialFriendDetailView addSubview:self.profilePictureImageView];
    [socialFriendDetailView addSubview:self.firstNameLabel];
    [socialFriendDetailView addSubview:self.lastNameLabel];
    [socialFriendDetailView addSubview:self.statusLabel];
    [socialFriendDetailView addSubview:self.currentPositionLabel];
    
    [self setFriend];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setFriend {
    self.firstNameLabel.text = _friend.firstName;
    self.lastNameLabel.text = _friend.lastName;
}

@end
