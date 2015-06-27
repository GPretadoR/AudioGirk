//
//  LeftViewCell.m
//  A2Test2
//
//  Created by Garnik Ghazaryan on 9/18/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

@synthesize imageView;
@synthesize label;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)log:(id)sender {
    NSLog(@"Pressed the");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
