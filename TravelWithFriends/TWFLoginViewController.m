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
#import "TWFSocialFriendListViewContainerViewController.h"

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

    TWFSocialFriendDataController *dataController = [[[TWFSocialFriendDataController alloc] init] autorelease];
    
    TWFAppDelegate *appDelegate = (TWFAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    //Set the attributes desired from facebook.
        NSMutableDictionary *friends = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"id, first_name, last_name, picture",@"fields",nil];
    
    //Make a request for the list of friends.
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
                   NSString *identity;
                   NSString *firstName;
                   NSString *lastName;
                   NSString *profilePicUrl;
                   NSArray *list = [success objectForKey:@"data"];
                   
                   if([list count] != 0) {
                       for (NSDictionary *data in list) {
                           identity = [data objectForKey:@"id"];
                           firstName = [data objectForKey:@"first_name"];
                           lastName = [data objectForKey:@"last_name"];
                           profilePicUrl = [[[data objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                           
                           //Add to the list of friends
                           [dataController addFriendWithIdentiyNum:identity firstName:firstName lastName:lastName profilePicUrl:profilePicUrl];
                       }

                       //Initalize view controller that handles response data from facebook, the creation of the list of friends and related views.
                       _friendListViewContainerController = [[TWFSocialFriendListViewContainerViewController alloc] initWithFriendList:dataController.socialFriendList];
                       [self.view addSubview:_friendListViewContainerController.view];
                   }
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

- (void) dealloc {
    [_customView release], _customView = nil;
    [_socialFriendDataController release], _socialFriendDataController = nil;
    [_socialFriendListViewController release], _socialFriendListViewController = nil;
    [_friendListViewContainerController release], _friendListViewContainerController = nil;
    
    [super dealloc];
}
@end
