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

- (id)init {
    if (self) {
        //Initalize datacontroller and social friends table view.
        self.socialFriendDataController = [[TWFSocialFriendDataController alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.socialFriendListViewController = [[TWFSocialFriendListViewController alloc] initWithFriendsList:self.socialFriendDataController.socialFriendList];
    
    //[self setSearchDisplayController:self.searchDisplayController];
	// Do any additional setup after loading the view.
    [self.view addSubview:self.socialFriendListViewController.view];
    [self.view bringSubviewToFront:self.socialFriendListViewController.view];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.socialFriendDataController release], self.socialFriendDataController = nil;
    [self.socialFriendListViewController release], self.socialFriendListViewController = nil;

    [super dealloc];
}

@end
