//
//  TWFSocialFriendDetailViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/9/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriendDetailViewController.h"
#import "TWFSocialFriendDetailView.h"

@interface TWFSocialFriendDetailViewController ()

@end

@implementation TWFSocialFriendDetailViewController

- (id)init {
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TWFSocialFriendDetailView *socialFriendDetailView = [[TWFSocialFriendDetailView alloc] initWithFrame:    [[UIScreen mainScreen] bounds]];
    [self.view addSubview:socialFriendDetailView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
