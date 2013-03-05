//
//  TWFLoginViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/4/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFLoginViewController.h"
#import "TWFLoginView.h"

@interface TWFLoginViewController ()

@end

@implementation TWFLoginViewController

- (id)init
{
    if (self) {
        //Set frame to the entire window size.
        self.view.frame = [[UIScreen mainScreen] bounds];
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        //Create a modal view with a pretty radial gradient background and other nice settings.
        _customView = [[[TWFLoginView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f)] autorelease];
        [self.view addSubview:_customView];        
        [_customView setCenter:self.view.center];
        
     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
