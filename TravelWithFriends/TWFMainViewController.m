//
//  TWFMainViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/4/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFMainViewController.h"
#import "TWFMapViewController.h"
#import "TWFLoginViewController.h"

@interface TWFMainViewController ()
@end

@implementation TWFMainViewController

- (id)init {
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create login view and add to this container.
    _loginViewController = [[TWFLoginViewController alloc] init];
    [self.view addSubview:_loginViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_loginViewController release], _loginViewController = nil;
    [super dealloc];
}

@end
