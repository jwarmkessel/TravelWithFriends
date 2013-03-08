//
//  TWFSocialFriend.h
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/6/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWFSocialFriend : NSObject

@property (nonatomic, copy) NSString *identityNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSURL *url;

-(id)initWithId:(NSString *)identityNum name:(NSString *)name profilePicUrl:(NSURL *)url;

@end
