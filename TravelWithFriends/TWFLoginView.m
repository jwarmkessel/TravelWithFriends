//
//  TWFLoginView.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/4/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFLoginView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TWFLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Gradient related variables
    CGGradientRef myGradient;
    CGColorSpaceRef myColorSpace;
    size_t locationCount = 2;
    CGFloat locationList[2] = { 0.0, 0.9 };
    CGFloat colorList[8] = {
        1.0, 1.0, 1.0, 1.0,  // Start color
        0.2, 0.32, 0.6, 1.0   // End color
        
    };
    
    myColorSpace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.5f];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.layer setShadowColor:[UIColor greenColor].CGColor];
    [self.layer setShadowOpacity:0.0];
    [self.layer setShadowRadius:3.0];
    
    
    
    float startPoint = 0.0f;
    float endPoint = self.frame.size.width;
    
    CGPoint startRadius, endRadius;
    
    //Radia Gradient Rendering
    startRadius.x = rect.size.width/2;
    startRadius.y = rect.size.height/2;
    endRadius.x = rect.size.width/2;
    endRadius.y = rect.size.height/2;
    
    CGContextDrawRadialGradient(ctx, myGradient, startRadius, startPoint, endRadius, endPoint, 0);
    CGGradientRelease(myGradient);

}


@end
