//
//  ReaderViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 10/24/13.
//  Copyright (c) 2013 Garnik Ghazaryan. All rights reserved.
//

#import "AGBarButtonItem.h"
#import "ReaderViewController.h"
#import "ReaderSettingsViewController.h"



#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define offset (iOSVersion7) ? 20:0

@implementation ReaderViewController {

    NSUserDefaults *userDefs;
    NSData *jquery;
    UIPopoverController *bookMarkPopover;
    UIPopoverController *shareViewPopover;
    BookMarkViewController *bookMarkViewController;
    UIButton *showBookMarks;
    UIButton *shareButton;
    UIButton *settingsButton;
    UIPopoverController *settingsPopover;
    NSArray *fontSizeNames;
    NSUInteger textFontSize;
}

@synthesize bookPathToLoad;
@synthesize bookID;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setLeftBarButtonItem:[[AGBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] target:self action:@selector(goBack)]];
    }
    return self;
}

#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    userDefs = [NSUserDefaults standardUserDefaults];
    readerSettings=[[ReaderSettingsViewController alloc]initWithNibName:@"ReaderSettingsViewController" bundle:nil];
    readerSettings.delegate = self;
    fontSizeNames = @[@"xx-small", @"x-small", @"small",@"medium", @"large", @"x-large", @"xx-large"];
    
    [self uiConfiguration];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (id subview in webView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    
//    textFontSize = 100;
    
    UIScrollView* sv = nil;
    for (UIView* v in  webView.subviews) {
        if([v isKindOfClass:[UIScrollView class]]){
            sv = (UIScrollView*) v;
            //			sv.scrollEnabled = NO;
            sv.delegate=self;
            sv.bounces = NO;
        }
    }

}

- (void)viewDidUnload {
    //	webView = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"scrHHH = %@", [webView stringByEvaluatingJavaScriptFromString:@"screen.width"]);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: bookPathToLoad]]];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void) uiConfiguration{
    
    float yOffset=0;
    if (iOSVersion7) {
        yOffset=20;
    }
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.origin.y - 108)];
    [webView setDelegate:self];
    [webView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:webView];
    
    NSLog(@"Readerview frame :%@",NSStringFromCGRect(webView.frame));
    UIImageView *bottomImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, webView.frame.origin.y + webView.frame.size.height, self.view.frame.size.width, 44)];
    bottomImageView.backgroundColor=[UIColor colorWithRed:0/255.0f green:169/255.0f blue:157/255.0f alpha:1.0f];
    bottomImageView.userInteractionEnabled=YES;
    [self.view addSubview:bottomImageView];
    
    
    
    
    UIButton *bookMarkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [bookMarkButton addTarget:self action:@selector(addBookMarkPressed) forControlEvents:UIControlEventTouchUpInside];
    bookMarkButton.frame=CGRectMake(5, 5, 172, 34);
    [bookMarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
    
    showBookMarks=[UIButton buttonWithType:UIButtonTypeCustom];
    [showBookMarks addTarget:self action:@selector(showBookMarksPressed) forControlEvents:UIControlEventTouchUpInside];
    showBookMarks.frame=CGRectMake(182, 5, 172, 34);
    [showBookMarks setTitle:@"Show Bookmarks" forState:UIControlStateNormal];
    
    shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame=CGRectMake(364, 5, 172, 34);
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    
    settingsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame=CGRectMake(546, 5, 172, 34);
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    
    [bottomImageView addSubview:bookMarkButton];
    [bottomImageView addSubview:showBookMarks];
    [bottomImageView addSubview:shareButton];
    [bottomImageView addSubview:settingsButton];
}

#pragma mark - Webview delegates and Javascript

/*Function Name : loadPage
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To load actual pages to webview
 */

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView1
{
    
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";

    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; width: %fpx;')", webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
//	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];

    NSString *setImageRule = [NSString stringWithFormat:@"addCSSRule('img', 'max-width: %fpx; max-height:%fpx;')", webView.frame.size.width,webView.frame.size.height];
    NSString *setImageRule2 = [NSString stringWithFormat:@"addCSSRule('image', 'max-width: %fpx; max-height:%fpx;')", webView.frame.size.width,webView.frame.size.height];
    
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
//	[webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];

	[webView stringByEvaluatingJavaScriptFromString:setImageRule];
    [webView stringByEvaluatingJavaScriptFromString:setImageRule2];
//  Removing all hrefs
    
    [self javascriptCalls];
    [self restoreSettings];
}

- (void) javascriptCalls{
    
    NSString *funcTrough=@"function removeHrefs(){"
    "var allAs=document.getElementsByTagName('a');"
    "for (var i=0; i<allAs.length;i++){"
    "var href= allAs[i].getAttribute('href');"
    "if(!!href){"
    "href=href.split('.html')[0];"
    "href='#'+href;"
    "allAs[i].setAttribute('href',href);}}};";
    
    NSString *funcCall=@"removeHrefs()";
    
    NSString *hideElement=@"function removeImage(){"
    "var allAs=document.getElementsByTagName('image');"
    "if (!!allAs[0]){"
    "var parent=allAs[0].parentNode;"
    "parent.parentNode.removeChild(parent);}};";
    NSString *callRemoveElement=@"removeImage()";
    
    [webView stringByEvaluatingJavaScriptFromString:funcTrough];
    [webView stringByEvaluatingJavaScriptFromString:funcCall];
    
    [webView stringByEvaluatingJavaScriptFromString:hideElement];
    [webView stringByEvaluatingJavaScriptFromString:callRemoveElement];
    
}
- (NSString*) getTextAtOffset:(float) yOffset {
    
    if (jquery == nil || [jquery length] == 0) {
        NSString *jqueryCDN = @"http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
        jquery = [NSData dataWithContentsOfURL:[NSURL URLWithString:jqueryCDN]];
    }
    NSString *jqueryString = [[NSMutableString alloc] initWithData:jquery encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jqueryString];
    NSString *getTextFromOffset = @"function getTextFromOffset(offset){"
    "var pHeight = 0;"
    "var pText = \"\";"
    "$(\"body>p\").each(function(){"
    "if(pHeight >= offset){"
    //    "alert(\"AFTER: \" +$(this).text() + pHeight + \" \" + offset);"
    "pText = $(this).text();"
    "return false;"
    "}else {"
    "pHeight += $(this).height() + parseInt($(this).css('margin-top'),10) + parseInt($(this).css('padding-top'),10) + parseInt($(this).css('margin-bottom'),10) + parseInt($(this).css('padding-bottom'),10);}});"
    "return pText;}";
    
    [webView stringByEvaluatingJavaScriptFromString:getTextFromOffset];
    NSString *jsCode = [NSString stringWithFormat:@"getTextFromOffset(%f)",yOffset];
    NSString *returnValue = [webView stringByEvaluatingJavaScriptFromString:jsCode] ;
    
    return returnValue;
}


/*
 Search A string inside UIWebView with the use of the javascript function
 */

- (NSInteger)stringHighlight:(NSString*)str
{
    // The JS File
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",str];
    [webView stringByEvaluatingJavaScriptFromString:startSearch];
    NSString *result        = [webView stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}

- (void)removeHighlights{
    [webView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];  // to remove highlight
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self removeHighlights];
    
    int resultCount = [self stringHighlight:searchBar.text];
    
    // If no occurences of string, show alert message
    if (resultCount <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LOL!"
                                                        message:[NSString stringWithFormat:@"Type again and You might find it: %@", searchBar.text]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }
    
    // remove kkeyboard
    [searchBar resignFirstResponder];
}


- (IBAction)removeHighlightsB{
    [webView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];  // to remove highlight
    [self.view endEditing:YES];
}

#pragma mark ACTIONS

- (IBAction) doneClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Done");
}



- (BOOL) canBecomeFirstResponder {
    return YES;
}
#pragma mark Toolbar Controls
- (void) addBookMarkPressed{
    
    NSArray *bookmarks = [userDefs objectForKey:[NSString stringWithFormat:@"bookmarks_%@",bookID]];
    NSMutableArray *marray = [NSMutableArray arrayWithArray:bookmarks];
    int yOffset = webView.scrollView.contentOffset.y;
    
    NSString *textAtOffset = [self getTextAtOffset:yOffset];
    NSString *record = [NSString stringWithFormat:@"%@- %d",textAtOffset,yOffset];
    
    if (![marray containsObject:record]) {
        [marray addObject:record];
        NSLog(@"Bookmark added...");
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Bookmark!" message:@"Bookmarked Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Cannot Bookmark" message:@"This page is already bookmarked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"Bookmark exists...");
    }
    bookmarks = [marray mutableCopy];
    //    bookMarksArray=[marray mutableCopy];
    //    NSLog(@"BooMark:%@",[bookMarksArray objectAtIndex:0]);
    [userDefs setObject:bookmarks forKey:[NSString stringWithFormat:@"bookmarks_%@",bookID]];
    [userDefs synchronize];
    
    
}
- (void) showBookMarksPressed{
    //    [userDefs removeObjectForKey:[NSString stringWithFormat:@"bookmarks_%@",bookID]];
    
    if (!bookMarkViewController) {
        bookMarkViewController=[[BookMarkViewController alloc]initWithNibName:@"BookMarkViewController" bundle:[NSBundle mainBundle]];
        bookMarkViewController.delegate = self;
        bookMarkViewController.bookID = bookID;
    }
    bookMarkViewController.bookMarksArray = [userDefs objectForKey:[NSString stringWithFormat:@"bookmarks_%@",bookID]];
    if(bookMarkPopover==nil){
        
        bookMarkPopover = [[UIPopoverController alloc] initWithContentViewController:bookMarkViewController];
        [bookMarkPopover setPopoverContentSize:CGSizeMake(320, 500)];
    }
    if (![bookMarkPopover isPopoverVisible]) {
        [bookMarkPopover presentPopoverFromRect:[showBookMarks bounds] inView:showBookMarks permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }else{
        [bookMarkPopover dismissPopoverAnimated:YES];
        bookMarkPopover=nil;
    }
    
}
- (void) shareButtonPressed:(id)sender{
    NSString *textToShare = @"your text";
    UIImage *imageToShare = [UIImage imageNamed:@"book.png"];
    NSArray *itemsToShare = @[textToShare, imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed){
        self.navigationController.navigationBar.hidden = NO;
    }];
    
    if(shareViewPopover==nil){
        
        shareViewPopover = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [shareViewPopover setPopoverContentSize:CGSizeMake(400, 300)];
    }
    if (![shareViewPopover isPopoverVisible]) {
        [shareViewPopover presentPopoverFromRect:[shareButton bounds] inView:shareButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }else{
        [shareViewPopover dismissPopoverAnimated:YES];
        shareViewPopover    =nil;
    }
}


- (void) settingsButtonPressed{
    
    settingsPopover=[[UIPopoverController alloc]initWithContentViewController:readerSettings];
    settingsPopover.delegate=self;
    settingsPopover.popoverContentSize=readerSettings.view.frame.size;
    [settingsPopover presentPopoverFromRect:[settingsButton bounds] inView:settingsButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)didBookMarkSelected:(float)contentYoffset {
    
    [webView.scrollView setContentOffset:CGPointMake(0, contentYoffset - 10) animated:YES];
    [bookMarkPopover dismissPopoverAnimated:YES];
}

#pragma mark Settings

- (void) restoreSettings{
    NSLog(@"day value :%d",[userDefs boolForKey:@"isDay"]);
    if ([userDefs objectForKey:@"isDay"] != nil) {
        if([userDefs boolForKey:@"isDay"]){
            readerSettings.switcherState=YES;
            [webView setOpaque:NO];
            [webView setBackgroundColor:[UIColor whiteColor]];
            NSString *jsString = [NSString  stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
            [webView stringByEvaluatingJavaScriptFromString:jsString];
        }else{
            readerSettings.switcherState=NO;
            [webView setOpaque:NO];
            [webView setBackgroundColor:[UIColor blackColor]];
            NSString *jsString = [NSString  stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
            [webView stringByEvaluatingJavaScriptFromString:jsString];
        }
    }
    textFontSize = [userDefs objectForKey:@"fontTextSize"]  ? [[userDefs objectForKey:@"fontTextSize"] integerValue]: 3;
    NSString *jsString = [NSString  stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize= '%@'", fontSizeNames[textFontSize]];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    
}

-(void)didBackgroundSwitchToDay:(BOOL)isDay{
    if (isDay) {
        [self day];
    }else {
        [self night];
    }
}

-(void)didTextSizeIncrease:(BOOL)didIncrease sliderValue:(int)sliderValue{ 
    textFontSize = sliderValue;
    [self changeTextSize];
}



-(void)changeTextSize{
    [userDefs setObject:[NSNumber numberWithInteger:textFontSize] forKey:@"fontTextSize"];
    [userDefs synchronize];

    NSString *jsString = [NSString  stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize= '%@'", fontSizeNames[textFontSize]];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}


-(void)day{
    
    [userDefs setBool:YES forKey:@"isDay"];
    [userDefs synchronize];
    
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor whiteColor]];
    NSString *jsString2 = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
    [webView stringByEvaluatingJavaScriptFromString:jsString2];
    
}



-(void)night{
    
    [userDefs setBool:NO forKey:@"isDay"];
    [userDefs synchronize];
    
    [webView setOpaque:NO];
    [webView setBackgroundColor:[UIColor blackColor]];
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
}





#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //    NSLog(@"shouldAutorotate");
    //    [self updatePagination];
    return NO;
}


#pragma mark -
#pragma mark Memory management

/*
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */


- (void)dealloc {

//	webView = nil;

}
@end
