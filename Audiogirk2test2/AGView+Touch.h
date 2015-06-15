//
//  AGImageView+Touch.h
//  A2Test2
//
//  Created by Garnik Ghazaryan on 8/30/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGView_Touch : UIView{
    
    SEL sel;
    id  targ;
    id instance;
    id anObject;
}

- (id)initWithFrame:(CGRect)frame selector:(SEL)selectr withObject:(id)object andTarget:(id)target fromInstance:(id)theInstance;

@end
