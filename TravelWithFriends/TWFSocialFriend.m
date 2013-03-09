//
//  TWFSocialFriend.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/6/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriend.h"

@implementation TWFSocialFriend
@synthesize identityNum = _identityNum, firstName = _firstName, lastName = _lastName, url = _url;

-(id)initWithId:(NSString *)identityNum firstName:(NSString *)fName lastName:(NSString *)lName profilePicUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.identityNum = identityNum;
        self.firstName = fName;
        self.lastName = lName;
        self.url = url;
        
        return self;
    }
    return nil;
}

@end
