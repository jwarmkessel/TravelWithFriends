//
//  TWFSocialFriend.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/6/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriend.h"

@implementation TWFSocialFriend
@synthesize identityNum = _identityNum, name = _name, url = _url;

-(id)initWithId:(NSString *)identityNum name:(NSString *)name profilePicUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _identityNum = identityNum;
        _name = name;
        _url = url;
        return self;
    }
    return nil;
}

@end
