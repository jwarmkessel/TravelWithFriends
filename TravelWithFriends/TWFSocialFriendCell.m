//
//  TWFSocialFriendCell.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/8/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriendCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TWFSocialFriendCell

-(void)dealloc {
    [_firstName release], _firstName = nil;
    [_lastName release], _lastName = nil;
    [_profilePicView release], _profilePicView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0.0f, 0.0f,44.0f, 44.0f);
    self.imageView.frame = CGRectMake(0.0f, 0.0f,44.0f, 44.0f);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 44;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = 77;
    self.detailTextLabel.frame = tmpFrame;
}



@end
