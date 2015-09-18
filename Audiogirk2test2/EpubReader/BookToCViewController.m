//
//  BookToCViewController.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "BookToCViewController.h"
#import "Utils.h"
@interface BookToCViewController ()

@end

@implementation BookToCViewController {

    NSString *documentDirectory;
    NSString *bookPath;
    NSString* content;
    bool isConcated;
    NSString *epubPath;
}

@synthesize _ePubContent;
@synthesize _rootPath;
@synthesize _strFileName;

@synthesize chapterTableView;
@synthesize bookObjDB;



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

#pragma mark View Lifecycle
- (void)viewDidLoad     
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
}
-(void)viewWillAppear:(BOOL)animated{
    
    documentDirectory = [Utils applicationDocumentsDirectory];
    
    _strFileName=[NSString stringWithFormat:@"%@.epub", bookObjDB.bookSourceID];
    epubPath= [NSString stringWithFormat:@"%@/%@_%@", documentDirectory, bookObjDB.format, bookObjDB.bookSourceID];
    
    loadedEpub=[[EPub alloc]initWithEPubPath:[NSString stringWithFormat:@"%@/%@",epubPath,_strFileName]];
//    for (int i=0; i<[loadedEpub.spineArray count]; i++) {
//        NSLog(@"Chapter Path:%@",[[loadedEpub.spineArray objectAtIndex:i] spinePath]);
//        NSLog(@"Chapter:%@",[[loadedEpub.spineArray objectAtIndex:i] title]);
//    }
    if (!readerViewController) {
        readerViewController=[[ReaderViewController alloc]initWithNibName:@"ReaderViewController" bundle:nil];
    }
    
    [chapterTableView reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    readerViewController=nil;
    _xmlHandler=nil;
    loadedEpub=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [loadedEpub.spineArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"bookToCCell";
    
    UITableViewCell *bookToCCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (bookToCCell == nil) {
        bookToCCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    bookToCCell.textLabel.text = [(loadedEpub.spineArray)[indexPath.row] title];
    return bookToCCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    readerViewController.bookPathToLoad=[(loadedEpub.spineArray)[indexPath.row]spinePath];
    readerViewController.bookID = bookObjDB.bookSourceID;
    [self.navigationController pushViewController:readerViewController animated:YES];
}



@end
