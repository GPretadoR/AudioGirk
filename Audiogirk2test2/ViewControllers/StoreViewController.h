//
//  ViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DecriptionViewController.h"

@interface StoreViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,DescriptionViewControllerDelegate>{
    
    UIScrollView *mainScrollView;
}

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) iCarousel *adBannerCar;
@property (strong, nonatomic) iCarousel *audioOnlyCar;
@property (strong, nonatomic) iCarousel *audioTextCar;
@property (strong, nonatomic) iCarousel *textOnlyCar;

@property (nonatomic, strong) UIViewController *child;
@property (nonatomic, strong) NSMutableArray *reserveStoreItems;

- (void)addChildViewController:(UIViewController *)childController;
-(void)showDescriptions:(id)object;
- (void) requestJson;

@end
