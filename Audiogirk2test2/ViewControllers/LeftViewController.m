//
//  LeftViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "LeftViewController.h"

//#import "MenuItem.h"
//#import "MenuCellView.h"
//#import "AlertsViewController.h"
//#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ServerRequest.h"
#import "Sec.h"
#import "AGNavBar.h"
#import "LeftViewCell.h"

#import "CategoriesViewController.h"
#import "WishListViewController.h"
#import "SettingsViewController.h"
#import "MyBooksViewController.h"
#import "AlreadyDownloadedViewController.h"

#import "BookItemsObject.h"
#import "Utils.h"
#import "ServerJSONRequest.h"

#import "SlideNavigationController.h"
#import "SVProgressHUD.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define offset (iOSVersion7)?20:0

@interface LeftViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation LeftViewController{

    LeftViewCell *leftViewcell;
    NSMutableArray *booksArray;
    NSArray *searchResult;
    BookItemsObject *bookObject;
    NSArray *iconsArray;
    ServerJSONRequest *serverJSONRequest;
}

@synthesize lTableView, storeViewController;


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        items = [NSMutableArray array];
    }
    return self;

}

#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if (iOSVersion7) {
        
    }
    serverJSONRequest = [[ServerJSONRequest alloc] init];
    
    [lTableView setSeparatorColor:[UIColor colorWithRed:206/255.0f green:85/255.0f blue:52/255.0f alpha:0.75f]];
    items = [NSMutableArray array];
    arrayOfSections=[[NSMutableArray alloc]initWithObjects:@"Store",@"Categories",@"Wish List",@"Settings",@"My Books",@"Already Downloaded", nil];
    iconsArray = @[@"storeIcon.png", @"categoriesIcon.png", @"wishLIstIcon.png", @"settingsIcon.png",  @"mybooksIcon.png",@"downloadedIcon.png"];
    lTableView.backgroundColor = [UIColor clearColor];
    [self searchBarConfig];
}
-(void)viewWillAppear:(BOOL)animated{
    
    CGRect tmpRect = lTableView.frame;
    tmpRect = CGRectMake(tmpRect.origin.x, 19, 306, tmpRect.size.height);
    lTableView.frame = tmpRect;
    lTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    booksArray = [storeViewController.reserveStoreItems mutableCopy];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) searchBarConfig{
    
    searchResult = [NSMutableArray array];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    lTableView.tableHeaderView = self.searchController.searchBar;
#if ENABLE_SCOPE_BUTTONS
    
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:NSLocalizedString(@"All", @"Search display controller All button.")];
    
    for (NSString *deviceType in [Product deviceTypeNames])
    {
        NSString *displayName = [Product displayNameForType:deviceType];
        [scopeButtonTitles addObject:displayName];
    }
    
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    self.searchController.searchBar.delegate = self;
    
#endif
    
    self.definesPresentationContext = YES;
    
    
    
    
}


#pragma mark Table View Config

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchController.active) {
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
    
    if (self.searchController.active){
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
            return .0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchController.active){
        bookObject = searchResult[indexPath.row];
        [storeViewController showDescriptions:bookObject];
    }else {
        if (indexPath.row == 0) {
            [NSThread detachNewThreadSelector:@selector(showWithStatus:) toTarget:[SVProgressHUD class] withObject:@"Loading..."];
            [serverJSONRequest checkInternetConnection:^(BOOL isReachable){
                [NSThread detachNewThreadSelector:@selector(dismiss) toTarget:[SVProgressHUD class] withObject:nil];
                NSInteger index = indexPath.row;
                if (!isReachable) {
                    index = 4;
                }
                [self chooseViewControllerWithIndex:index];
            }];
        }else{
            [self chooseViewControllerWithIndex:indexPath.row];
        }
    }
    
}

#pragma mark Other Methods

- (void) chooseViewControllerWithIndex:(NSInteger)index{
    UIViewController *newPage = nil;

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
            CategoriesViewController *catVC = [[CategoriesViewController alloc]initWithNibName:@"CategoriesViewController" bundle:nil];
            newPage = catVC;
        }
            break;
        case 2:
        {
            newPage = [[WishListViewController alloc]initWithNibName:@"WishListViewController" bundle:nil];
        }
            break;
        case 3:
        {
            newPage = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        }
            break;
        case 4:
        {
            newPage = [[MyBooksViewController alloc]initWithNibName:@"MyBooksViewController" bundle:nil];
        }
            break;
        case 5:
        {
            newPage = [[AlreadyDownloadedViewController alloc]initWithNibName:@"AlreadyDownloadedViewController" bundle:nil];
        }
            break;
        default:
            break;
    }
    
    [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:newPage
                                                          withSlideOutAnimation:NO
                                                                  andCompletion:nil];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSString *scope = nil;
    
    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0) {
        scope = [booksArray objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    
    [self filterContentForSearchText:searchString scope:scope];
    
    [lTableView reloadData];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


#pragma mark - Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"b_name contains[c] %@ OR b_author contains[c] %@", searchText, searchText];
    searchResult = [booksArray filteredArrayUsingPredicate:resultPredicate];
}
@end
