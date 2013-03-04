//
//  TWFAppDelegate.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/2/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFAppDelegate.h"
#import "TWFMainViewController.h"
#import "SFSocialFacebook.h"

@implementation TWFAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Initialize SFSocialFacebook with the desired pemissions.
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"create_event", @"user_events", @"rsvp_event", @"publish_stream", nil];
    _socialFacebook = [SFSocialFacebook sharedInstanceWithAppId:@"434318013270211" appSecret:@"d265589f1ef81b3bb3a6a6559d3a66f2" urlSchemeSuffix:nil andPermissions:permissions];
    [permissions release];
    
    //Init the window and the first view controller
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainViewController = [[[TWFMainViewController alloc] init] autorelease];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
