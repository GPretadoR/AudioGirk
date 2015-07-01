//
//  ViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/20/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "StoreViewController.h"
#import "AGBarButtonItem.h"

#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AGView+Touch.h"
#import "ServerRequest.h"
#import "Sec.h"

#import "StoreCollectionViewCell.h"

#import "LeftViewCell.h"
#import "MyBooksViewController.h"
#import "InfoViewController.h"
#import "Downloader.h"
#import "Utils.h"

#import "BookItemsModel.h"
#import "ServerJSONRequest.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define offset (iOSVersion7)?20:0

#import "LoginViewController.h"

@interface StoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) BookItemsModel *bookModel;
@end

@implementation StoreViewController {
    
    NSDictionary *dict;
    NSDictionary *bannerDict;
    UIImageView *waitingViewImage;
    UIImageView *buttonBG;
    CGPoint pointNow;
    
    UIButton *audioBut;
    UIButton *audioTextBut;
    UIButton *textBut;
    
    
    UIImageView *a;
    UICollectionView *_collectionView;
    
    ServerRequest *serverRequest;
    int indexOfItemSelected;
    float screenOriginX;
    float screenOriginY;
    
    NSMutableArray *storeItems;
    NSMutableArray *bannerItems;
    
    DecriptionViewController *descrView;
    MyBooksViewController *myBookViewController;
    InfoViewController *infoViewController;
    
    BookItemsObject *bookItemObj;
    BannerItemObject *bannerItemObj;
    ServerJSONRequest *serverJSONRequest;
}

BOOL isScrollPressed=NO;


@synthesize nav,child;
@synthesize adBannerCar,textOnlyCar,audioOnlyCar,audioTextCar;
@synthesize behavior;
@synthesize reserveStoreItems;



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"---STORE---";
        UIStoryboard *stBd=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [stBd instantiateViewControllerWithIdentifier:@"storeViewController"];
        //Set VC title label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20.0];
        titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        // ^-Use UITextAlignmentCenter for older SDKs.
        titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:73.0/255.0 blue:95.0/255.0 alpha:1]; // change this color
        self.navigationItem.titleView = titleLabel;
        titleLabel.text = NSLocalizedString(@"STORE", @"");
        [titleLabel sizeToFit];

#if TARGET_IPHONE_SIMULATOR
        NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
        
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ShowMenu.png"] target:self action:@selector(showMenu)]];
        
        //Set custom buttons
        UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        
        UIView *parentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        UIButton *sliderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 30, 32)];
        [sliderButton setBackgroundImage:[UIImage imageNamed: @"navbtn.png"] forState:UIControlStateNormal];
        [sliderButton setTitle:@"Slide" forState:UIControlStateNormal];
        sliderButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        sliderButton.titleLabel.textColor = [UIColor whiteColor];
        [sliderButton addTarget:self action:@selector(scroll) forControlEvents:UIControlEventTouchUpInside];
        [parentView1 addSubview:sliderButton];
        UIBarButtonItem *slideBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:parentView1];
        
        NSArray *buttonsArray=@[modalButton,slideBarButtonItem];
        
        [self.navigationItem setRightBarButtonItems:buttonsArray];
        
    }
    return self;
}

#pragma mark View LifeCycle

-(void)viewWillAppear:(BOOL)animated{
}


- (void)viewDidLoad
{
//    LoginViewController *loginView = [[LoginViewController alloc] init];
//    [self.navigationController presentViewController:loginView animated:YES completion:nil];
    
    serverRequest = [[ServerRequest alloc] init];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    NSString *str = [Sec createKey];
    //    __block BOOL requestDidNotFinished=TRUE;
    ////    NSString *key=[Sec getKey];
    //    NSString *url = [NSString stringWithFormat:@"http://109.68.124.16/api/v1/books"];
    //    [serverRequest getWithUrlString:url completion:^(NSArray *itms){
    //        if ([itms count]==0) {
    //            return ;
    //        }
    //        reserveStoreItems=[NSMutableArray array];
    //        [reserveStoreItems addObjectsFromArray:itms];
    //        if (requestDidNotFinished) {
    //            requestDidNotFinished=FALSE;
    //        }else{
    //            [waitingViewImage removeFromSuperview];
    //            requestDidNotFinished=TRUE;
    //        }
    //        NSLog(@"Store Items: %@",[storeItems objectAtIndex:0]);
    //        storeItems = [[NSMutableArray alloc] initWithArray:[reserveStoreItems objectAtIndex:0]];
    //        [storeTableView reloadData];
    //
    //    }];
    
    //    ServerRequest *serverRequest1 = [[ServerRequest alloc] init];
    //    [serverRequest1 getWithUrlString:@"http://109.68.124.16/api/v1/banners" completion:^(NSArray *banItems){
    //        if ([banItems count]==0) {
    //            return ;
    //        }
    //
    //        bannerItems=[NSMutableArray array];
    //        [bannerItems addObjectsFromArray:banItems];
    //        NSLog(@"Banner Items %@",[bannerItems objectAtIndex:1]);
    //        if (requestDidNotFinished) {
    //            requestDidNotFinished=FALSE;
    //        }else{
    //            [waitingViewImage removeFromSuperview];
    //            requestDidNotFinished=TRUE;
    //        }
    //
    //        [adBannerCar reloadData];
    //
    //    }];
    
    [self uiConfiguration];
    //    [self waitingView];
    
    descrView = [[DecriptionViewController alloc]init];
    descrView.modalPresentationStyle = UIModalPresentationFormSheet;
    descrView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    descrView.delegate = self;
    
    infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:[NSBundle mainBundle]];
    infoViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    
    serverJSONRequest = [[ServerJSONRequest alloc] init];
    [serverJSONRequest checkInternetConnection:^(BOOL isReachable){
        if (isReachable) {
            [self requestJson];
        }
    }];
    
    
}


- (void) requestJson {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //code executed in the background
        //2
        NSData* booksJsonData = [NSData dataWithContentsOfURL:
                                 [NSURL URLWithString:@"http://109.68.124.16/api/v1/books"]
                                 ];
        NSData* bannersJsonData = [NSData dataWithContentsOfURL:
                                   [NSURL URLWithString:@"http://109.68.124.16/api/v1/banners"]
                                   ];
        NSData* categoryJsonData = [NSData dataWithContentsOfURL:
                                    [NSURL URLWithString:@"http://109.68.124.16/api/v1/categories"]
                                    ];
        //3
        
        NSArray* booksJson = [NSJSONSerialization
                              JSONObjectWithData:booksJsonData
                              options:NSJSONReadingMutableContainers
                              error:nil];
        NSArray* bannersJson = [NSJSONSerialization
                                JSONObjectWithData:bannersJsonData
                                options:NSJSONReadingMutableContainers
                                error:nil];
        
        NSArray* categoryJson = [NSJSONSerialization
                                 JSONObjectWithData:categoryJsonData
                                 options:NSJSONReadingMutableContainers
                                 error:nil];
        
        NSDictionary *jsonDict = @{@"bookItemsArray": booksJson[0],@"bannerItemsArray": bannersJson[0],@"categoryItemsArray": categoryJson};
        //4
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            //5
            NSError *err;
            self.bookModel = [BookItemsModel sharedModelWithDictionary:jsonDict];
            
            if (err) {
                NSLog(@"Unable to initialize BookItemsModel, %@", err.localizedDescription);
            }else {
                bannerItems = [self.bookModel.bannerItemsArray mutableCopy];
                reserveStoreItems = [self.bookModel.bookItemsArray mutableCopy];
                storeItems = [reserveStoreItems mutableCopy];
                [adBannerCar reloadData];
                [_collectionView reloadData];
            }
        });
        
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark initial UI configurations

- (void)uiConfiguration{
    
    //    self.view.backgroundColor=[UIColor lightGrayColor];
    screenOriginX=self.view.frame.origin.x;
    screenOriginY=self.view.frame.origin.y+offset;
    
    if (![UIApplication sharedApplication].statusBarHidden) {
        screenOriginY-=20;
    }
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"vv.png"]; //bkg-3.jpg bkg-7.jpg bkg-9.jpg Blur-1.png
    [self.view addSubview:bgImageView];
    
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    nav=appDelegate.navigationController;
    //Init iCarousels
    adBannerCar=[[iCarousel alloc]initWithFrame:CGRectMake(screenOriginX, screenOriginY, 768, 300)];
    //    adBannerCar.layer.borderColor=[UIColor blackColor].CGColor;
    //    adBannerCar.layer.borderWidth=2.0;
    adBannerCar.backgroundColor=[UIColor clearColor];
    
    adBannerCar.dataSource=self;
    adBannerCar.delegate=self;
    self.adBannerCar.type=iCarouselTypeCylinder;
    
    buttonBG=[[UIImageView alloc]initWithFrame:CGRectMake(screenOriginX,screenOriginY+300, self.view.frame.size.width, 58)];
    //    buttonBG.image=[UIImage imageNamed:@"buttonBack.png"];
    buttonBG.backgroundColor = [UIColor colorWithRed:235/255.0f green:200/255.0f blue:94/255.0f alpha:1.0f];
    [self.view addSubview:buttonBG];

    [self configureCollectionView];
    
    //Audio Button
    audioBut=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [audioBut setTitle:@"AudioBook" forState:UIControlStateNormal];
    audioBut.titleLabel.textAlignment=NSTextAlignmentRight;
    [audioBut setTitleColor:[UIColor colorWithRed:51.0/255.0 green:73.0/255.0 blue:95.0/255.0 alpha:1] forState:UIControlStateNormal];
    audioBut.frame=CGRectMake(78, buttonBG.frame.origin.y, 205, 58);
    [audioBut addTarget:self action:@selector(audioButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    //Audio + Text Button
    audioTextBut=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [audioTextBut setTitle:@"Book&AudioBook" forState:UIControlStateNormal];
    [audioTextBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    audioTextBut.titleLabel.textAlignment=NSTextAlignmentCenter;
    audioTextBut.frame=CGRectMake(282, buttonBG.frame.origin.y, 205, 58);
    [audioTextBut addTarget:self action:@selector(audioTextButtonPressed:) forControlEvents:UIControlEventTouchDown];
    audioTextBut.backgroundColor=[UIColor colorWithRed:232/255.0f green:103/255.0f blue:65/255.0f alpha:1.0f];
    
    //Text Button
    textBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [textBut setTitle:@"Book" forState:UIControlStateNormal];
    [textBut setTitleColor:[UIColor colorWithRed:51.0/255.0 green:73.0/255.0 blue:95.0/255.0 alpha:1] forState:UIControlStateNormal];
    textBut.titleLabel.textAlignment=NSTextAlignmentCenter;
    textBut.frame=CGRectMake(487, buttonBG.frame.origin.y, 205, 58);
    [textBut addTarget:self action:@selector(textButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:audioBut];
    [self.view addSubview:audioTextBut];
    [self.view addSubview:textBut];
    
    [self.view addSubview:adBannerCar];
    
    
}
- (void) configureCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(screenOriginX,screenOriginY+360, self.view.frame.size.width, 600) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView registerNib:[UINib nibWithNibName:@"StoreCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"myCellIdentifier"];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
}


- (void)waitingView{
    
    waitingViewImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    waitingViewImage.backgroundColor=[UIColor grayColor];
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(waitingViewImage.frame.size.width/2-15, waitingViewImage.frame.size.height/2-15, 30, 30)];
    
    [waitingViewImage addSubview:activityIndicator];
    [self.view addSubview:waitingViewImage];
    
    activityIndicator.color=[UIColor blackColor];
    [activityIndicator startAnimating];
    
    
}
- (void)addChildViewController:(UIViewController *)childController {
    self.child = childController;
    [super addChildViewController:childController];
}

#pragma mark iCarousel

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //generate 100 item views
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return [bannerItems count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
        if (carousel==adBannerCar) {
            //            view = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil] lastObject];
            if ([bannerItems count]!=0) {
                //                NSLog(@"JSON:%@",[items objectAtIndex:index]);
                bannerDict = bannerItems[index];
                bannerItemObj = bannerItems[index];
                
                NSURL *imageURL=[NSURL URLWithString:bannerItemObj.b_image];
                view = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil] lastObject];
                
                view.layer.shadowColor = [UIColor blackColor].CGColor;
//                view.layer.shadowOffset = CGSizeMake(30, -5);
                view.layer.shadowOpacity = 0.5;
                view.layer.shadowRadius = 15.0;
                view.layer.cornerRadius = 15.0f;
                view.layer.shouldRasterize = YES;
                view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-15.0f, 0, view.frame.size.width + 30.0f , view.frame.size.height)].CGPath;
                
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                imageView.clipsToBounds = YES;
                imageView.layer.cornerRadius = 15.0f;
//                imageView.backgroundColor = [UIColor redColor];
                [imageView setImageWithURL:imageURL];
                imageView.contentMode=UIViewContentModeScaleToFill;
     
                imageView.userInteractionEnabled=YES;
                [view addSubview:imageView];
                
                
            }
        }
    }
    
    return view;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{

    [self showDescriptions:bannerItems[index]];

}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            if (carousel == adBannerCar)
            {
                //add a bit of spacing between the item views
                return value * 1.35f;
            }
        }
        default:
        {
            return value;
        }
    }
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return 300;
}



#pragma mark Collection view delegates;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [storeItems count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCollectionViewCell *cell = (StoreCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"myCellIdentifier" forIndexPath:indexPath];
    bookItemObj = storeItems[indexPath.row];

    cell.stAuthorName.text = bookItemObj.b_author;
    cell.stBookName.text = bookItemObj.b_name;
    [cell.stImageView setImageWithURL:[NSURL URLWithString:bookItemObj.b_image]];
    
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
    bookItemObj = storeItems[indexPath.row];
    [self showDescriptions:bookItemObj];
    
}

- (void)scroll{

    UIViewAnimationOptions animOntion=UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:0.2 delay:0 options:animOntion
                     animations:^(){
                         if (!isScrollPressed) {
                             [self slideScreenUp:YES];
                             isScrollPressed=YES;
                         }else{
                             [self slideScreenUp:NO];
                             isScrollPressed=NO;
                         }
                         
                     } completion:^(BOOL finished){
                         //Do Something after finsihed
                     }];
    
}

- (void)slideScreenUp:(BOOL)dir1isUP{

    if (dir1isUP==1) {
        
        adBannerCar.frame = [self changeFramePosition:adBannerCar.frame byY:410 andX:0 toDirection:1];
       
        audioBut.frame = [self changeFramePosition:audioBut.frame byY:306 andX:0 toDirection:1];
        
        audioTextBut.frame = [self changeFramePosition:audioTextBut.frame byY:306 andX:0 toDirection:1];
        
        textBut.frame = [self changeFramePosition:textBut.frame byY:306 andX:0 toDirection:1];
        
        buttonBG.frame = [self changeFramePosition:buttonBG.frame byY:306 andX:0 toDirection:1];
        
//        storeTableView.frame=[self changeFramePosition:storeTableView.frame byY:306 andX:0 toDirection:1];
        
        CGRect newFrame = _collectionView.frame;
        newFrame.origin.y -= 306;
        newFrame.size.height += 306;
        _collectionView.frame = newFrame;
        
    }else{

        
        adBannerCar.frame = [self changeFramePosition:adBannerCar.frame byY:410 andX:0 toDirection:0];
        
        audioBut.frame = [self changeFramePosition:audioBut.frame byY:306 andX:0 toDirection:0];
        
        audioTextBut.frame = [self changeFramePosition:audioTextBut.frame byY:306 andX:0 toDirection:0];
        
        textBut.frame = [self changeFramePosition:textBut.frame byY:306 andX:0 toDirection:0];
        
        buttonBG.frame = [self changeFramePosition:buttonBG.frame byY:306 andX:0 toDirection:0];
        

        
        CGRect newFrame=_collectionView.frame;
        newFrame.origin.y+=306;
        newFrame.size.height-=306;
        _collectionView.frame=newFrame;
    }
}

- (CGRect)changeFramePosition:(CGRect)currentRect byY:(float)Y andX:(float)X toDirection:(BOOL)direction{


    CGRect newRect=currentRect;
    if (direction==1) {
        newRect.origin.y-=Y;
    }else{
        newRect.origin.y+=Y;
    }
    currentRect=newRect;
    
    return currentRect;
}


#pragma mark Actions
- (void) createJSONBodyWithObjects:(NSArray*)objects andKey:(NSString*)key{
    BookItemsObject *bio;
    [storeItems removeAllObjects];
    for (int i = 0; i < [objects count]; i++) {
        bio = objects[i];
        if ([bio.format isEqualToString:key]) {
            [storeItems addObject:bio];
        }
    }

    [_collectionView reloadData];
}

- (IBAction)audioButtonPressed:(id)sender{
    [self changeButtonBackGroundColor:sender];
    [self createJSONBodyWithObjects:reserveStoreItems andKey:@"audio"];
    //TODO: Iterate through json and check format
    //TODO: Change Items variable
}

- (IBAction)audioTextButtonPressed:(id)sender{
    [self changeButtonBackGroundColor:sender];
    [self createJSONBodyWithObjects:reserveStoreItems andKey:@"mixed"];
    
}
- (IBAction)textButtonPressed:(id)sender{
    [self changeButtonBackGroundColor:sender];
    [self createJSONBodyWithObjects:reserveStoreItems andKey:@"text"];
}

-(void)changeButtonBackGroundColor:(id)sender{

    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        audioBut.backgroundColor=[UIColor clearColor];
        audioTextBut.backgroundColor=[UIColor clearColor];
        textBut.backgroundColor=[UIColor clearColor];

        audioBut.titleLabel.textColor=[UIColor colorWithRed:0 green:167/255.0 blue:157/255.0 alpha:1];
        audioTextBut.titleLabel.textColor=[UIColor colorWithRed:0 green:167/255.0 blue:157/255.0 alpha:1];
        textBut.titleLabel.textColor=[UIColor colorWithRed:0 green:167/255.0 blue:157/255.0 alpha:1];
        
        [sender setBackgroundColor:[UIColor colorWithRed:232/255.0f green:103/255.0f blue:65/255.0f alpha:1.0f]];//[UIColor colorWithRed:25.0/255.0 green:121.0/255.0 blue:126.0/255.0 alpha:1]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } completion:nil];
}

- (void)infoButtonAction{
    [self presentViewController:infoViewController animated:YES completion:nil];
}
- (void)showMenu {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


-(void)showDescriptions:(id)object{
    
    if ([object isKindOfClass:[BookItemsObject class]]) {
        descrView.bookItemObject = object;
        [self presentViewController:descrView animated:YES completion:nil];
    }else if ([object isKindOfClass:[BannerItemObject class]]) {
        descrView.bannerItemObject = object;
        [self presentViewController:descrView animated:YES completion:nil];
    }
    
}

- (void)openBookPressed{
    
    myBookViewController = [[MyBooksViewController alloc]initWithNibName:@"MyBooksViewController" bundle:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIViewController *viewToPush = [myBookViewController checkControllerForBookType:descrView.bookFormat];
    [self.navigationController pushViewController:viewToPush animated:YES];
    //    [myBookViewController showReader:descrView.bookDictionary];
}



@end
