//
//  LeftViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreViewController.h"

@interface LeftViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *items;
    NSMutableArray *arrayOfSections;

}
@property (weak, nonatomic) IBOutlet UITableView *lTableView;

@property (strong, nonatomic) StoreViewController *storeViewController;
@end
