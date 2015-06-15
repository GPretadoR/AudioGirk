//
//  CategoriesViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesViewController : UIViewController{
    
    UITableView *categoriesTableView;
    NSMutableArray *categoriesItems;
}
- (IBAction)pushView:(id)sender;

@end
