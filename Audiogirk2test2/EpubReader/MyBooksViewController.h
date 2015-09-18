//
//  MyBooksViewController.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
@interface MyBooksViewController : UIViewController {

    NSMutableArray *myBooksItems;
    UIImageView *myBooksImage;
    
    SQLiteManager *dbManager;
    

}


- (UIViewController*)checkControllerForBookType:(NSString*)bookFormat;
@end
