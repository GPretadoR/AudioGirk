//
//  BookMarkViewController.m
//  masterTest1
//
//  Created by Admin on 07/11/2012.
//  Copyright (c) 2012 Garnik Ghazaryan. All rights reserved.
//

#import "BookMarkViewController.h"

@interface BookMarkViewController ()

@end

@implementation BookMarkViewController{

    UIButton *editButton;
    NSUserDefaults *userDefs;
}

@synthesize bkCurrentPageInSpineIndex,bkCurrentSpineIndex,bkCurrentTextSize;
@synthesize bookMarkTableView;
@synthesize bookMarksArray,bookID;
@synthesize delegate;
@synthesize bmNavBarButtonItem,BMNavItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [bookMarksArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    if (![bookMarksArray count]==0) {
        
        NSString* element=[bookMarksArray objectAtIndex:indexPath.row];
        NSArray * components=[element componentsSeparatedByString:@"-"];
        NSString * rowText= [components objectAtIndex:0];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",rowText];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.textLabel.adjustsFontSizeToFitWidth = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* element=[bookMarksArray objectAtIndex:indexPath.row];
    NSArray * components=[element componentsSeparatedByString:@"-"];
    [delegate didBookMarkSelected:[[components objectAtIndex:1] floatValue]];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editing forRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if( editing == UITableViewCellEditingStyleDelete ) {
        NSArray *bookmarks = [userDefs objectForKey:[NSString stringWithFormat:@"bookmarks_%@",bookID]];
        NSMutableArray *marray = [NSMutableArray arrayWithArray:bookmarks];
        [marray removeObjectAtIndex:indexPath.row];
        bookmarks = [marray mutableCopy];
        bookMarksArray = [marray mutableCopy];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        [userDefs setObject:bookmarks forKey:[NSString stringWithFormat:@"bookmarks_%@",bookID]];
        [userDefs synchronize];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if ([bookMarksArray count] > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [bookMarkTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefs = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidDisappear:(BOOL)animated{
//    epubViewContr.bookMarkPopover=nil;
}
- (IBAction)editButton:(id)sender {
    
    if([bookMarkTableView isEditing]) {
        [bmNavBarButtonItem setTitle:@"Edit"];
        [bookMarkTableView setEditing:NO animated:YES];
    } else {
        [bmNavBarButtonItem setTitle:@"Done"];
        [bookMarkTableView setEditing:YES animated:YES];
    }
    
}

- (void) uiConfiguration {
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
