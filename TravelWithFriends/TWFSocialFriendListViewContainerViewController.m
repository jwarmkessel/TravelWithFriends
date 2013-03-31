//
//  TWFSocialFriendListViewContainerViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/8/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriendListViewContainerViewController.h"

@interface TWFSocialFriendListViewContainerViewController ()

@end

@implementation TWFSocialFriendListViewContainerViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_socialFriendListViewController release], _socialFriendListViewController = nil;
    [_socialFriendList release], _socialFriendList = nil;
    
    [super dealloc];
}

- (id)initWithFriendList:(NSMutableArray *)array {
    self = [super init];
    if (self) {
        _socialFriendList = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _socialFriendListViewController = [[TWFSocialFriendListViewController alloc] initWithFriendsList:_socialFriendList];
    
	// Do any additional setup after loading the view.
    [self.view addSubview:_socialFriendListViewController.view];
    [self.view bringSubviewToFront:_socialFriendListViewController.view];
}
@end
