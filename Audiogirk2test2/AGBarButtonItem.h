//
//  AGBarButtonItem.h
//  A2Test2
//
//  Created by Garnik Ghazaryan on 8/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGBarButtonItem : UIBarButtonItem {
    UIButton *button;
}
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end
