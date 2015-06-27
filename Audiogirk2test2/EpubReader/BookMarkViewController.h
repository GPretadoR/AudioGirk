//
//  BookMarkViewController.h
//  masterTest1
//
//  Created by Admin on 07/11/2012.
//  Copyright (c) 2012 Garnik Ghazaryan. All rights reserved.
//

@protocol BookMarkViewControllerDelegate <NSObject>

- (void) didBookMarkSelected:(float) contentYoffset;

@end

#import <UIKit/UIKit.h>


@interface BookMarkViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{

    UITableView* bookMarkTableView;



}
@property (strong, nonatomic) IBOutlet UINavigationItem *BMNavItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bmNavBarButtonItem;

@property (nonatomic, retain) IBOutlet UITableView* bookMarkTableView;

@property (nonatomic, retain) NSString *bookID;
@property (nonatomic) int bkCurrentSpineIndex;
@property (nonatomic) int bkCurrentPageInSpineIndex;
@property (nonatomic) int bkCurrentTextSize;

@property (nonatomic, retain) NSArray *bookMarksArray;
@property (nonatomic) id delegate;

@end
