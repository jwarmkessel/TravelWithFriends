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
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *url;

-(id)initWithId:(NSString *)identityNum firstName:(NSString *)fName lastName:(NSString *)lName profilePicUrl:(NSString *)url;

@end
