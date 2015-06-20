//
//  LeftViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "LeftViewController.h"
#import "IIViewDeckController.h"
//#import "MenuItem.h"
//#import "MenuCellView.h"
//#import "AlertsViewController.h"
//#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ServerRequest.h"
#import "Sec.h"
#import "AGNavBar.h"
#import "LeftViewCell.h"
#import "StoreViewController.h"
#import "CategoriesViewController.h"
#import "WishListViewController.h"
#import "SettingsViewController.h"
#import "MyBooksViewController.h"
#import "AlreadyDownloadedViewController.h"

#import "BookItemsObject.h"
#import "Utils.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define offset (iOSVersion7)?20:0

@interface LeftViewController ()

@end

@implementation LeftViewController{

    LeftViewCell *leftViewcell;
    StoreViewController *storeViewController;
    NSMutableArray *booksArray;
    NSArray *searchResult;
    BookItemsObject *bookObject;
    NSArray *iconsArray;
}

@synthesize lTableView;


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style])) {
//        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
//        self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+offset, self.tableView.frame.size.width, self.tableView.frame.size.width);
//        self.tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.tableView.delegate = self;
        items = [NSMutableArray array];
       
    }
    return self;
}

#pragma mark Table View Config

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        bookObject = searchResult[indexPath.row];
        [storeViewController showDescriptions:bookObject];
    }else {
        [self chooseViewControllerWithIndex:indexPath.row];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResult count];
        
    } else {
        return [arrayOfSections count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //    NSString *sectionTitle=@"Main";
    
    if (section==0) {
        //        return sectionTitle;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    leftViewcell=(LeftViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (leftViewcell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftViewCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[LeftViewCell class]])
                leftViewcell = (LeftViewCell *)oneObject;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        bookObject = searchResult[indexPath.row];
        leftViewcell.imageView.image = [UIImage imageNamed:@"bookTypeIndicatorSmall.png"];
        leftViewcell.label.text = bookObject.b_name;
    } else {
        leftViewcell.imageView.image = [UIImage imageNamed:iconsArray[indexPath.row]];
        leftViewcell.label.text = arrayOfSections[indexPath.row];
    }
    
    if (indexPath.row == 1) {
        leftViewcell.frame = CGRectMake(leftViewcell.frame.origin.x, leftViewcell.frame.origin.y, leftViewcell.frame.size.width, leftViewcell.frame.size.height+50);

    }else{
        leftViewcell.frame = CGRectMake(leftViewcell.frame.origin.x, leftViewcell.frame.origin.y, leftViewcell.frame.size.width, 44);
    }
    return leftViewcell;
    
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell=leftViewcell;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.backgroundColor = [UIColor clearColor];
        leftViewcell.label.textColor=[UIColor whiteColor];//[UIColor colorWithRed:73.0/255.0f green:95.0/255.0f blue:112.0/255.0f alpha:1];
    } else {
        cell.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:17.0/255.0f green:17.0/255.0f blue:17.0/255.0f alpha:1];
        leftViewcell.label.textColor=[UIColor whiteColor];//[UIColor colorWithRed:73.0/255.0f green:95.0/255.0f blue:112.0/255.0f alpha:1];
    }

    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    switch (section) {
        case 0:
             break;
        case 1:
        case 2:
        case 3:
        case 4:
            break;
        default:
            break;
    }
    
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.0f;
        case 1:
        case 2:
        case 3:
        case 4:
            return 9.0f;
        default:
            break;
    }
    return 0.0f;
}

- (IBAction)log:(id)sender {
    NSLog(@"Pressed the1");
}
#pragma mark Other Methods

- (void) chooseViewControllerWithIndex:(NSInteger)index{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        UIViewController *newPage = nil;
        BOOL modal = NO;
        switch (index) {
            case 0:
            {
                //Show Store View;
                storeViewController = nil;
                if (!storeViewController) {
                    storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
                }
                newPage=storeViewController;
            }
                break;
            case 1:
            {
                CategoriesViewController *catVC=[[CategoriesViewController alloc]initWithNibName:@"CategoriesViewController" bundle:nil];
                newPage=catVC;
            }
                break;
            case 2:
            {
                newPage=[[WishListViewController alloc]initWithNibName:@"WishListViewController" bundle:nil];
            }
                break;
            case 3:
            {
                
                newPage=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
            }
                break;
            case 4:
            {
                newPage=[[MyBooksViewController alloc]initWithNibName:@"MyBooksViewController" bundle:nil];
            }
                break;
            case 5:
            {
                newPage=[[AlreadyDownloadedViewController alloc]initWithNibName:@"AlreadyDownloadedViewController" bundle:nil];
            }
                break;
                
            default:
                break;
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ( newPage != nil ) {
            UINavigationController *nc = appDelegate.navigationController;
            if ( modal ) {
                UINavigationController *nav1 = [[UINavigationController alloc] initWithNavigationBarClass:[AGNavBar class] toolbarClass:nil];
                [nav1 setViewControllers:@[newPage]];
                [nc presentViewController:nav1 animated:YES completion:nil];
            } else {
                [nc popToRootViewControllerAnimated:NO];
                [nc pushViewController:newPage animated:YES];
            }
        }
        
        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
    }];
    
}


#pragma mark SearchDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.backgroundColor = rgba(243, 119, 75, 1);
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"b_name contains[c] %@ OR b_author contains[c] %@", searchText, searchText];
    searchResult = [booksArray filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if (iOSVersion7) {

    }
    
    [lTableView setSeparatorColor:[UIColor colorWithRed:206/255.0f green:85/255.0f blue:52/255.0f alpha:0.75f]];
    items=[NSMutableArray array];
    arrayOfSections=[[NSMutableArray alloc]initWithObjects:@"Store",@"Categories",@"Wish List",@"Settings",@"My Books",@"Already Downloaded", nil];
    iconsArray = @[@"storeIcon.png", @"categoriesIcon.png", @"wishLIstIcon.png", @"settingsIcon.png",  @"mybooksIcon.png",@"downloadedIcon.png"];
    
//    NSString *key=[Sec getKey];
//    NSString *url = [NSString stringWithFormat:@"http://tiktakto.com/catalog/api/mobile?key=%@&type=home_category", key];
//    ServerRequest *serverRequest = [[ServerRequest alloc] init];
//    [serverRequest getWithUrlString:url completion:^(NSArray *itms){
//        items=[NSMutableArray array];
//        [items addObjectsFromArray:itms];
//        [lTableView reloadData];
//    }];

   }
-(void)viewWillAppear:(BOOL)animated{

    CGRect tmpRect = lTableView.frame;
    tmpRect = CGRectMake(tmpRect.origin.x, 19, 306, tmpRect.size.height);
    lTableView.frame = tmpRect;
    lTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    storeViewController = appDelegate.storeView;
    booksArray = [storeViewController.reserveStoreItems mutableCopy];
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
