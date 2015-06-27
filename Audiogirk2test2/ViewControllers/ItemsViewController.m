//
//  ItemsViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 12/10/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "ItemsViewController.h"
#import "StoreCollectionViewCell.h"
#import "Sec.h"
#import "ServerRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AGBarButtonItem.h"
#import "AGView+Touch.h"
#import "ReaderViewController.h"


@interface ItemsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ItemsViewController{
    
    UICollectionView *_collectionView;
}

-(void)showReader:(NSDictionary*)dictionaryOfItems{
    
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
    ReaderViewController *readerView=[[ReaderViewController alloc]initWithNibName:@"ReaderViewController" bundle:nil];
    [self.navigationController pushViewController:readerView animated:YES];
    
}



- (void)waitingView{
    
    itemImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    itemImage.backgroundColor=[UIColor grayColor];
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(itemImage.frame.size.width/2-15, itemImage.frame.size.height/2-15, 30, 30)];
    
    [itemImage addSubview:activityIndicator];
    [self.view addSubview:itemImage];
    
    activityIndicator.color=[UIColor blackColor];
    [activityIndicator startAnimating];
    
    
}


- (void)viewDidLoad
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    [self configureCollectionView];
    NSString *key=[Sec getKey];
    NSString *url = [NSString stringWithFormat:@"http://tiktakto.com/catalog/api/mobile?key=%@&type=live_feed&limit=10&page=%d", key,1];
    ServerRequest *serverRequest = [[ServerRequest alloc] init];
    [serverRequest getWithUrlString:url completion:^(NSArray *itms){
        if ([itms count]==0) {
            return ;
        }
        itemItems=[NSMutableArray array];
        [itemItems addObjectsFromArray:itms];
        [itemImage removeFromSuperview];
        //        NSLog(@"%@",[itemItems objectAtIndex:0]);
        [_collectionView reloadData];
        
    }];
    [self waitingView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] target:self action:@selector(goBack)]];
    }
    return self;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Done");
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
}

#pragma mark Collection view delegates;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [itemItems count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCollectionViewCell *cell = (StoreCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"myCellIdentifier" forIndexPath:indexPath];
    [cell.stImageView setImageWithURL:[NSURL URLWithString:itemItems[indexPath.row][@"image_url"]]];
    
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
    
}

@end
