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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    titleLabel.text = @"Location Sync With";
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [_socialFriendDetailView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 44.0f, 320.0f, 44.0f)];
    firstNameLabel.text = self.friend.firstName;
    [firstNameLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:firstNameLabel];
    [firstNameLabel release];
    
    UILabel *lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 88.0f, 320.0f, 44.0f)];
    lastNameLabel.text = self.friend.lastName;
    [lastNameLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:lastNameLabel];
    [lastNameLabel release];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 132.0f, 320.0f, 44.0f)];
    statusLabel.text = @"Status: ";
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:statusLabel];
    [statusLabel release];
    
    UILabel *currentPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 176.0f, 320.0f, 44.0f)];
    currentPositionLabel.text = @"Current: ";
    [currentPositionLabel setBackgroundColor:[UIColor clearColor]];
    [_socialFriendDetailView addSubview:currentPositionLabel];
    [currentPositionLabel release];
    
    self.profilePictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 75.0f, 75.0f)];
    [_socialFriendDetailView addSubview:self.profilePictureImageView];
    
    _startCaravanBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0.0f, 370.0f, 320.0f, 44.0f)] autorelease];
    _startCaravanBtn.titleLabel.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    _startCaravanBtn.titleLabel.hidden = NO;
    _startCaravanBtn.titleLabel.text = @"Start Caravan";
    _startCaravanBtn.titleLabel.textColor = [UIColor whiteColor];
    _startCaravanBtn.titleLabel.textAlignment = UITextAlignmentCenter;

    [_startCaravanBtn.layer setMasksToBounds:YES];
    [_startCaravanBtn.layer setCornerRadius:5.0f];
    [_startCaravanBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [_startCaravanBtn.layer setBorderWidth:1.5f];
    [_startCaravanBtn.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [_startCaravanBtn.layer setShadowColor:[UIColor greenColor].CGColor];
    [_startCaravanBtn.layer setShadowOpacity:0.0];
    [_startCaravanBtn.layer setShadowRadius:3.0];
    
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
    self.profilePictureImageView.backgroundColor = [UIColor blackColor];
    NSLog(@"Image %@", _friend.imageView.image);
    self.profilePictureImageView.image = _friend.imageView.image;
    [self.view bringSubviewToFront:self.profilePictureImageView];
}

- (void)dealloc {
    [_friend release], _friend = nil;
    [_startCaravanBtn release], _startCaravanBtn = nil;
    [_currentPositionLabel release], _currentPositionLabel = nil;
    [_statusLabel release]; _statusLabel = nil;
    [_lastNameLabel release], _lastNameLabel = nil;
    [_firstNameLabel release], _firstNameLabel = nil;
    [_titleLabel release], _titleLabel = nil;
    [_socialFriendDetailView release], _socialFriendDetailView = nil;
    [super dealloc];
}
@end
