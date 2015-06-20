//
//  AGImageView+Touch.m
//  A2Test2
//
//  Created by Garnik Ghazaryan on 8/30/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "AGView+Touch.h"

@implementation AGView_Touch



- (instancetype)initWithFrame:(CGRect)frame selector:(SEL)selectr withObject:(id)object andTarget:(id)target fromInstance:(id)theInstance {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        sel=selectr;
        targ=target;
        instance=theInstance;
        anObject=object;
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}



-(void)tapHandler:(UITapGestureRecognizer *)gesture{
    
    if (gesture.state==UIGestureRecognizerStateEnded) {
        CGPoint touchPoint=[gesture locationInView:self];
        BOOL isInsideOfView= [self pointInside:touchPoint withEvent:nil];
        if (isInsideOfView) {
            if (sel!=nil && instance!=nil) {
                [instance performSelectorOnMainThread:sel withObject:anObject waitUntilDone:YES];
            }
        }
    }
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//
//    UITouch *touch=[touches anyObject];
//    CGPoint touchPoint=[touch locationInView:self];
//    BOOL isInsideOfView= [self pointInside:touchPoint withEvent:nil];
//    if (isInsideOfView) {
//        if (sel!=nil && instance!=nil) {
//            [instance performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
//        }
//        NSLog(@"touched");
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
