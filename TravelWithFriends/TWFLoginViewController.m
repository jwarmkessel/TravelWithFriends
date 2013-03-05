//
//  TWFLoginViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/4/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFLoginViewController.h"
#import "TWFLoginView.h"
#import "TWFAppDelegate.h"

@interface TWFLoginViewController ()
- (void)handlefbButton:sender;
- (void)loginFinished;
@end

@implementation TWFLoginViewController

- (id)init
{
    if (self) {
        //Set frame to the entire window size.
        self.view.frame = [[UIScreen mainScreen] bounds];
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Create a modal view with a pretty radial gradient background and other nice settings.
    _customView = [[[TWFLoginView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 300.0f)] autorelease];
    [self.view addSubview:_customView];
    [_customView setCenter:self.view.center];
    
    
    //Add the FB login button
    UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbButton.frame = CGRectMake(0.0f, _customView.layer.frame.origin.y + 1000, 251.0f, 44.0f);
    UIImage *fbButtonImg = [UIImage imageNamed:@"Facebook-connect-btn.jpg"];
    [fbButton setBackgroundImage:fbButtonImg forState:UIControlStateNormal];
    [fbButton.layer setMasksToBounds:YES];
    [fbButton.layer setCornerRadius:5.0f];
    [fbButton setCenter:CGPointMake((_customView.frame.size.width/2), 44.0f)];
    [_customView addSubview:fbButton];
    [fbButton addTarget:self action:@selector(handlefbButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlefbButton:sender {
    NSLog(@"click");
    TWFAppDelegate *appDelegate = (TWFAppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate.socialFacebook loginWithSuccess:^{NSLog(@"Login successful!"); [self loginFinished];} failure:^(BOOL finished){NSLog(@".");}];
}

- (void)loginFinished {
    
    NSLog(@"Login finished");
}
@end
