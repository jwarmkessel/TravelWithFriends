//
//  TWFSocialFriendDataController.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/6/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWFSocialFriend;

@interface TWFSocialFriendDataController : NSObject

@property (retain, nonatomic) NSMutableArray *socialFriendList;

- (NSUInteger)countOfList;
- (TWFSocialFriend *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addFriendWithIdentiyNum:(NSString *)identityNum firstName:(NSString *)fName lastName:(NSString *)lName profilePicUrl:(NSString *)url;

@end
