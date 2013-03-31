//
//  TWFSocialFriendDataController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/6/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriendDataController.h"
#import "TWFSocialFriend.h"

@interface TWFSocialFriendDataController ()
- (void)initializeDefaultDataList;
@end

@implementation TWFSocialFriendDataController

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

+ (TWFSocialFriendDataController *)instance
{
static TWFSocialFriendDataController *instance = nil;

@synchronized(self)
{
    if (instance == nil)
    {
        instance = [[TWFSocialFriendDataController alloc] init];
    }
}

return instance;
}

- (void)initializeDefaultDataList {
    self.socialFriendList= [[[NSMutableArray alloc] init] autorelease];
}

- (void)setStayingFriendsList:(NSMutableArray *)newList {
    if (_socialFriendList != newList) {
        _socialFriendList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList
{
    return [self.socialFriendList count];
}

- (TWFSocialFriend *)objectInListAtIndex:(NSUInteger)theIndex
{
    return [self.socialFriendList objectAtIndex:theIndex];
}

- (void)addFriendWithIdentiyNum:(NSString *)identityNum firstName:(NSString *)fName lastName:(NSString *)lName profilePicUrl:(NSString *)url {

    TWFSocialFriend *newFriend= [[[TWFSocialFriend alloc] initWithId:identityNum firstName:fName lastName:lName profilePicUrl:url] autorelease];
    
    [self.socialFriendList addObject:newFriend];
}

- (void)dealloc {
    [_socialFriendList release], _socialFriendList = nil;
    
    [super dealloc];
}

@end
