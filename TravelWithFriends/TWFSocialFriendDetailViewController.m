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
    _socialFriendDetailView = [[TWFSocialFriendDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_socialFriendDetailView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    self.titleLabel.text = @"Location Sync With";
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    [_socialFriendDetailView addSubview:self.titleLabel];
    
    self.profilePictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 75.0f, 75.0f)];
    [_socialFriendDetailView addSubview:self.profilePictureImageView];
    
    self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 44.0f, 320.0f, 44.0f)];
    self.firstNameLabel.text = self.friend.firstName;
    [self.firstNameLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:self.firstNameLabel];
    
    self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 88.0f, 320.0f, 44.0f)];
    self.lastNameLabel.text = self.friend.lastName;
    [self.lastNameLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:self.lastNameLabel];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 132.0f, 320.0f, 44.0f)];
    self.statusLabel.text = @"Status: ";
    [self.statusLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:self.statusLabel];
    
    self.currentPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 176.0f, 320.0f, 44.0f)];
    self.currentPositionLabel.text = @"Current: ";
    [self.currentPositionLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:self.currentPositionLabel];
    
    
    self.startCaravanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 370.0f, 320.0f, 44.0f)];
    self.startCaravanBtn.titleLabel.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    self.startCaravanBtn.titleLabel.hidden = NO;
    self.startCaravanBtn.titleLabel.text = @"Start Caravan";
    self.startCaravanBtn.titleLabel.textColor = [UIColor whiteColor];
    self.startCaravanBtn.titleLabel.textAlignment = UITextAlignmentCenter;

    [self.startCaravanBtn.layer setMasksToBounds:YES];
    [self.startCaravanBtn.layer setCornerRadius:5.0f];
    [self.startCaravanBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.startCaravanBtn.layer setBorderWidth:1.5f];
    [self.startCaravanBtn.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.startCaravanBtn.layer setShadowColor:[UIColor greenColor].CGColor];
    [self.startCaravanBtn.layer setShadowOpacity:0.0];
    [self.startCaravanBtn.layer setShadowRadius:3.0];
    
    [_socialFriendDetailView addSubview:self.startCaravanBtn];
    
    //Set the first name and last name
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

- (void)dealloc {
    [self.friend release], self.friend = nil;
    [self.startCaravanBtn release], self.startCaravanBtn = nil;
    [self.currentPositionLabel release], self.currentPositionLabel = nil;
    [self.statusLabel release]; self.statusLabel = nil;
    [self.lastNameLabel release], self.lastNameLabel = nil;
    [self.firstNameLabel release], self.firstNameLabel = nil;
    [self.titleLabel release], self.titleLabel = nil;
    [_socialFriendDetailView release], _socialFriendDetailView = nil;
    [super dealloc];
}
@end
