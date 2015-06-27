//
//  StoreCollectionViewCell.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 4/3/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stImageView;
@property (weak, nonatomic) IBOutlet UILabel *stBookName;
@property (weak, nonatomic) IBOutlet UILabel *stAuthorName;
@property (strong, nonatomic) IBOutlet UIButton *stPrice;
@property (strong, nonatomic) IBOutlet UIImageView *stBookIcon;
@property (strong, nonatomic) IBOutlet UIImageView *stHeadPhoneIcon;

@end
