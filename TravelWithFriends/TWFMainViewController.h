//
//  TWFMainViewController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/4/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWFLoginViewController;
@class TWFMapViewController;

@interface TWFMainViewController : UIViewController {
    TWFLoginViewController *_loginViewController;
}

@property (strong) TWFMapViewController *mapViewController;

@end
