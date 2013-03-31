//
//  TWFSocialFriend.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/6/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriend.h"

@implementation TWFSocialFriend

-(void)dealloc {
    [_identityNum release], _identityNum = nil;
    [_firstName release], _firstName = nil;
    [_lastName release], _firstName = nil;
    [_url release], _firstName = nil;
    
    [super dealloc];
}
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
