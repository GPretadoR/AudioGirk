//
//  AGBarButtonItem.m
//  A2Test2
//
//  Created by Garnik Ghazaryan on 8/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "AGBarButtonItem.h"

@implementation AGBarButtonItem

- (instancetype)initWithImage:(UIImage *)image
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    self = [super initWithCustomView:button];
    if (self) {
        CGFloat buttonWidth = image.size.width;
        CGFloat buttonHeight = image.size.height;
        button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        self.width = buttonWidth;
        
        // Normal state background
        UIImage *backgroundImage = image;
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        // Pressed state background
        backgroundImage = image;
        [button setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    self = [super initWithCustomView:button];
    if (self) {
        self.target = target;
        self.action = action;
        
        CGFloat buttonWidth = image.size.width;
        CGFloat buttonHeight = image.size.height;
        button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        self.width = buttonWidth;
        
        // Normal state background
        UIImage *backgroundImage = image;
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        // Pressed state background
        backgroundImage = image;
        [button setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
