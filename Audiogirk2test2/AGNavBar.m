//
//  AGNavBar.m
//  A2Test2
//
//  Created by Garnik Ghazaryan on 8/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "AGNavBar.h"

@implementation AGNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIColor * color = [UIColor colorWithRed:235/255.0f green:200/255.0f blue:94/255.0f alpha:1.0f];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    CGContextFillRect(context, rect);
}

@end
