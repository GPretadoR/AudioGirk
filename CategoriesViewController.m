//
//  CategoriesViewController.m
//  A2Test2
//
//  Created by Garnik Ghazaryan on 9/18/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "CategoriesViewController.h"
#import "AGBarButtonItem.h"
#import "MyBooksViewController.h"
#import "Sec.h"
#import "ServerRequest.h"
#import "CategoriesCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AGView+Touch.h"
#import "ItemsViewController.h"

#import "BookItemsModel.h"
#import "CategoriesItemObject.h"

@interface CategoriesViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

UIImageView *waitViewImage;

@implementation CategoriesViewController {

    CategoriesItemObject *categoryItemObject;
    BookItemsModel *bookItemModel;
    NSMutableArray *categoryItemsArray;
    UICollectionView *_collectionView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSLog(@"Inited");
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] target:self action:@selector(goBack)]];
        
        categoriesItems=[NSMutableArray array];
    }
    return self;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)waitingView{
    
    waitViewImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    waitViewImage.backgroundColor=[UIColor grayColor];
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(waitViewImage.frame.size.width/2-15, waitViewImage.frame.size.height/2-15, 30, 30)];
    
    [waitViewImage addSubview:activityIndicator];
    [self.view addSubview:waitViewImage];
    
    activityIndicator.color=[UIColor blackColor];
    [activityIndicator startAnimating];
    
    
}
#pragma mark Methods

-(void)showItems:(NSDictionary*)dictionaryOfItems{
    
    //    indexOfItem=adBannerCar.currentItemIndex;
    
    //    DecriptionViewController *descrView=[[DecriptionViewController alloc]init];
    //    descrView.modalPresentationStyle=UIModalPresentationFormSheet;
    //    descrView.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    //
    //    //[[[[adBannerCar.currentItemView subviews]lastObject]subviews]lastObject];
    //    [self presentViewController:descrView animated:YES completion:nil];
    //    [descrView.descrImageView setImageWithURL:[dictionaryOfItems objectForKey:@"image_url"]];
    //    descrView.bookName.text=[dictionaryOfItems objectForKey:@"title"];
    //    descrView.description.text=[dictionaryOfItems objectForKey:@"description"];
    //    descrView.price.text=[NSString stringWithFormat:@"$%@",[dictionaryOfItems objectForKey:@"price"]];

    
    ItemsViewController *itemView=[[ItemsViewController alloc]initWithNibName:@"ItemsViewController" bundle:nil];
    [self.navigationController pushViewController:itemView animated:YES];
    
}



#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    bookItemModel = [BookItemsModel sharedModel];
    categoriesItems = [bookItemModel.categoryItemsArray mutableCopy];
    
    [self configureCollectionView];
    
//    [self waitingView];
    // Do any additional setup after loading the view from its nib.
}
- (void) configureCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height + 20) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"categoriesCellIdentifier"];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Collection view delegates;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [categoriesItems count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoriesCollectionViewCell *cell = (CategoriesCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"categoriesCellIdentifier" forIndexPath:indexPath];
    categoryItemObject = [categoriesItems objectAtIndex:indexPath.row];
    

    cell.cvLabel.text = categoryItemObject.name;
    [cell.cvImageView setImageWithURL:[NSURL URLWithString:categoryItemObject.imageURL]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(250, 250);
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
    categoryItemObject = [categoriesItems objectAtIndex:indexPath.row];
    [self showItems:categoryItemObject.toDictionary];
    
}

- (IBAction)pushView:(id)sender {
    ItemsViewController *mb=[[ItemsViewController alloc]initWithNibName:@"ItemsViewController" bundle:nil];
    [self.navigationController pushViewController:mb animated:YES];
    
}
@end
