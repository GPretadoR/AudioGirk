//
//  InfoViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 3/23/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "InfoViewController.h"
#import "Utils.h"

@interface InfoViewController ()

@end

@implementation InfoViewController{

    UITextView *informTextView;
    UIButton *closeButton;
    UIImageView *logoView;
    
    CGSize screenSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 540, 620);
    screenSize = self.view.frame.size;
    [self uiConfigurations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) uiConfigurations{
    
    [Utils setViewToAddOn:self.view];
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"vv.png"]; //bkg-3.jpg bkg-7.jpg bkg-9.jpg Blur-1.png
    [self.view addSubview:bgImageView];
    
    informTextView = [Utils createTextViewWithRect:CGRectMake(screenSize.width/2 - 200, screenSize.height/2 - 100, 400, 200) contentText:@"iGirk-ը իրենից ներկայացնում է էլեկտրոնային և աուդիո գրականության համար նախատեսված հավելված։ Հավելվածում համակցվել են աուդիո և տեքստային տարբերակները ու «վարձակալության» մեխանիզմը: iGirk-ի հիմնական առավելություններն են ծառայության մատչելիությունը, հարմարավետությունը և շարժունակությունը: Մատչելիությունը ապահովվում է ծառայության հարմար արժեքով, իսկ հարմարավետությունը՝ հեշտ օգտագործմամբ: Ժամանակակից աշխարհում ժամանակի սղության պայմաններում ծառայության շարժունակությունը դարձել է այն հենասյունը, որի վրա հիմնվում է կազմակերպության գործունեությունը:"];
    informTextView.backgroundColor = [UIColor clearColor];
    informTextView.textAlignment = NSTextAlignmentCenter;
    
    closeButton = [Utils createButtonInRect:CGRectMake(screenSize.width - 50, 10, 40, 40) title:@"X" target:self action:@selector(closeButtonPressed) backGroundImage:nil highlightImage:nil];
    logoView = [Utils createImageViewWithRect:CGRectMake(50, 50, 150, 150) image:[UIImage imageNamed:@"placeholder.png"]];
}

#pragma mark Actions

- (void) closeButtonPressed{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
