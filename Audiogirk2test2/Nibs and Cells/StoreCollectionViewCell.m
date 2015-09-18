//
//  StoreCollectionViewCell.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/3/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "StoreCollectionViewCell.h"

@implementation StoreCollectionViewCell



@synthesize stAuthorName;
@synthesize stBookName;
@synthesize stImageView;
@synthesize stBookIcon;
@synthesize stHeadPhoneIcon;

- (void)awakeFromNib {
    // Initialization code

}

- (void) showIconWithFormat:(NSString *)bookFormat{
    stBookIcon.hidden = NO;
    stHeadPhoneIcon.hidden = NO;
    if ([bookFormat isEqualToString:@"audio"]) {
        stBookIcon.hidden = YES;
        stHeadPhoneIcon.frame = CGRectMake(120, 92, 41, 28);
    }else if ([bookFormat isEqualToString:@"text"]){
        stHeadPhoneIcon.hidden = YES;
    }else {
        stHeadPhoneIcon.frame = CGRectMake(170, 92, 41, 28);
    }
}
@end
