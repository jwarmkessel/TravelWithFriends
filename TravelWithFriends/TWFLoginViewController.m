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
#import "TWFSocialFriendDataController.h"
#import "TWFSocialFriendListViewController.h"

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
        self.socialFriendDataController = [[TWFSocialFriendDataController alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Create a modal view with a pretty radial gradient background and other nice settings.
    _customView = [[[TWFLoginView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 300.0f)] autorelease];
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

//Facebook connect. Then get and load list of friends.
- (void)handlefbButton:sender {
    TWFAppDelegate *appDelegate = (TWFAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *friends = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"id, name, picture",@"fields",nil];
    
    [appDelegate.socialFacebook
     getAppAccessTokenWithSuccess:^(NSString* success) {
         NSLog(@"Get token successful: %@", success);
         
         [appDelegate.socialFacebook
          loginWithSuccess:^(void){
       
              [appDelegate.socialFacebook
               facebookRequestWithGraphPath:@"me/friends"
               params:friends httpMethod:@"GET"
               needsLogin:NO
               success:^(id success) {
                   NSMutableArray *friends = [[[NSMutableArray alloc]init] autorelease];
                   NSString *identity;
                   NSString *name;
                   NSString *profilePicUrl;

                   NSArray *list = [success objectForKey:@"data"];

                   for (NSDictionary *data in list)
                   {
                       identity = [data objectForKey:@"id"];
                       name = [data objectForKey:@"name"];
                       profilePicUrl = [[[data objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                       NSURL *url = [[NSURL alloc]initWithString:profilePicUrl];

                       
                       [self.socialFriendDataController addFriendWithIdentiyNum:identity name:name profilePicUrl:url];
                   }
                   
                   self.socialFriendListViewController = [[TWFSocialFriendListViewController alloc] initWithFriendsList:self.socialFriendDataController.socialFriendList];
                   
                
                   [self.view addSubview:self.socialFriendListViewController.view];
                   [self.view bringSubviewToFront:self.socialFriendListViewController.view];
                   

               }
               failure:^(NSError *error) {
                   NSLog(@"Request FB friends Error %@", error);
               }
               cancel:^{
                   NSLog(@"cancelled FB friends Error");
               }];
              
          }
          failure:^(BOOL finished) {
              NSLog(@"LoginWithSuccess Failed");
          }];
     }
     failure:^(NSError* error) {
         NSLog(@"getAppAccessTokenWithSuccess Error %@", error);
     }];
}

- (void)loginFinished {
    
    NSLog(@"Login finished");
}

@end
