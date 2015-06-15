//
//  DecriptionViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItemsModel.h"
#import "BannerItemObject.h"
@protocol DescriptionViewControllerDelegate <NSObject>

@optional - (void) openBookPressed;

@end

@interface DecriptionViewController : UIViewController


- (IBAction)closeController:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *descrImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (nonatomic, retain) NSString *bookID;
@property (nonatomic, retain) NSString *bookFormat;

@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *sampleButton;
@property (nonatomic, retain) NSDictionary *bookDictionary;

@property (nonatomic, strong) BookItemsObject  *bookItemObject;
@property (nonatomic, strong) BannerItemObject *bannerItemObject;

@property (nonatomic) id delegate;
@end
