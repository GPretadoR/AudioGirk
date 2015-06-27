//
//  LeftViewCell.h
//  A2Test2
//
//  Created by Garnik Ghazaryan on 9/18/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)log:(id)sender;
@end
