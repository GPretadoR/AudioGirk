//
//  MyBooksViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/22/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "MyBooksViewController.h"
#import "StoreCollectionViewCell.h"
#import "Sec.h"
#import "ServerRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AGBarButtonItem.h"
#import "AGView+Touch.h"
#import "BookToCViewController.h"
#import "AudioPlayerViewController.h"

#import "BookItemsModel.h"
#import "BookItemsObject.h"
#import "BookObjectFromDB.h"
#import "Utils.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define offset (iOSVersion7)?20:0

@interface MyBooksViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) BookItemsModel *bookModel;
@end


@implementation MyBooksViewController{

    BookToCViewController *bookTableOfContent;
    AudioPlayerViewController *audioPlayerViewController;
    
    BookItemsObject *bookItemObject;
    NSMutableArray *bookItemsArray;
    
    UICollectionView *_collectionView;
    NSDictionary *myBookItemsDict;
    BookObjectFromDB *bookObjectFromDB;
    
    BOOL isEditing;
    
}
@synthesize bookModel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!bookTableOfContent) {
            bookTableOfContent=[[BookToCViewController alloc]initWithNibName:@"BookToCViewController" bundle:nil];
        }
        if (!audioPlayerViewController) {
            audioPlayerViewController = [[AudioPlayerViewController alloc] init];
        }
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ShowMenu.png"] target:self action:@selector(goBack)]];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBookModel];
    
    self.title = @"My Books";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self uiConfigurations];
    
    dbManager = [SQLiteManager sharedDBManager];
    [dbManager getDatabaseDump];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT myBooks.*, author.bookAuthorName FROM 'bookAuthor' INNER JOIN author ON bookAuthor.authorId = author.authorId INNER JOIN myBooks ON bookAuthor.bookId = myBooks.id;"];
    myBooksItems = [NSMutableArray  arrayWithArray:[dbManager getRowsForQuery:sqlStr]];
    
    bookObjectFromDB = [BookObjectFromDB sharedObjectFromArray:myBooksItems];
    
    [self configureCollectionView];

    // Do any additional setup after loading the view from its nib.
}
- (void) configureCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView registerNib:[UINib nibWithNibName:@"StoreCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"myCellIdentifier"];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uiConfigurations {

    
//    UIView *parentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 30, 32)];
    [editButton setBackgroundImage:[UIImage imageNamed: @"navbtn.png"] forState:UIControlStateNormal];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    editButton.titleLabel.textColor = [UIColor whiteColor];
    [editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [parentView1 addSubview:sliderButton];
    UIBarButtonItem *editBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:editButton];
    NSArray *buttonsArray=@[editBarButtonItem];
    
    [self.navigationItem setRightBarButtonItems:buttonsArray];
}



- (void)waitingView{
    
    myBooksImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myBooksImage.backgroundColor=[UIColor grayColor];
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(myBooksImage.frame.size.width/2-15, myBooksImage.frame.size.height/2-15, 30, 30)];
    
    [myBooksImage addSubview:activityIndicator];
    [self.view addSubview:myBooksImage];
    
    activityIndicator.color=[UIColor blackColor];
    [activityIndicator startAnimating];
    
    
}

#pragma mark Collection view delegates;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [myBooksItems count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCollectionViewCell *cell = (StoreCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"myCellIdentifier" forIndexPath:indexPath];

    bookObjectFromDB = [BookObjectFromDB getBookObjectForDictionary:myBooksItems[indexPath.row]];
    [cell.stImageView setImageWithURL:[NSURL URLWithString:bookObjectFromDB.bookImageName]];
    cell.stAuthorName.text = bookObjectFromDB.bookAuthorName;
    cell.stBookName.text = bookObjectFromDB.bookName;
    [cell showIconWithFormat:bookObjectFromDB.format];
    if (isEditing) {
        UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 32, 32)];
        deleteView.image = [UIImage imageNamed:@"delete.png"];
        [cell addSubview:deleteView];
        [deleteView bringSubviewToFront:_collectionView];
    }else{
        for (UIView *view in cell.subviews) {
            if (CGRectEqualToRect(view.frame, CGRectMake(4, 4, 32, 32))) {
                [view removeFromSuperview];
            }
        }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(245, 130);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,5,0,0);  // top, left, bottom, right
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Selected items # %ld",(long)indexPath.row);
    NSDictionary *currentBookObject = myBooksItems[indexPath.row];
    bookObjectFromDB = [BookObjectFromDB getBookObjectForDictionary:currentBookObject];
    if (isEditing) {
        [self deleteObject:bookObjectFromDB atIndexPath:indexPath];
    }else{
        [self showReader:bookObjectFromDB];
    }
    
    
}
#pragma mark Actions

- (void)createBookModel{
    bookModel = [BookItemsModel sharedModel];
    bookItemsArray = [bookModel.bookItemsArray mutableCopy];
    
}
- (void)goBack {
//    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Done");
}


-(void)editButtonPressed {
    isEditing = !isEditing;
    [_collectionView reloadData];
}
- (void) deleteObject:(BookObjectFromDB*)bookObjectDB atIndexPath:(NSIndexPath*)indexPath{
    
    [_collectionView performBatchUpdates:^{

        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM 'myBooks' WHERE id = \"%@\"", bookObjectFromDB.id];
        [dbManager doQuery:sqlStr];
        [myBooksItems removeObjectAtIndex:indexPath.row]; // self.images is my data source
        NSString *filename = [NSString stringWithFormat:@"%@_%@", bookObjectFromDB.format, bookObjectFromDB.bookSourceID];
        [Utils deleteFolderAtPath:filename inDocumentsDirectory:TRUE];
        [Utils deleteFolderAtPath:[NSString stringWithFormat:@"%@.zip",filename] inDocumentsDirectory:TRUE];
        // Now delete the items from the collection view.
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:nil];
}

-(void)showReader:(BookObjectFromDB*)bookObject{

    bookTableOfContent.bookObjDB = (BookObjectFromDB*)bookObject;
    audioPlayerViewController.bookObjDB = (BookObjectFromDB*)bookObject;

    UIViewController *viewToPush = [self checkControllerForBookType:bookObjectFromDB.format]; //TODO: Wrong BookID check with Aram
    [self.navigationController pushViewController:viewToPush animated:YES];
    
}
- (UIViewController*)checkControllerForBookType:(NSString*)bookFormat{
    
    UIViewController *viewControllerToPush;
    if ([@"audio" isEqualToString:bookFormat]){ //Wrong BookID check with Aram
        viewControllerToPush = audioPlayerViewController;
    }else{
        viewControllerToPush = bookTableOfContent;
    }
    return viewControllerToPush;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
