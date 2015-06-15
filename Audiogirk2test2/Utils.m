//
//  Utils.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/25/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "Utils.h"
#import "ZipArchive.h"

UIView *localView;
@implementation Utils {
    
}
+ (UISwitch*)createSwitchWithRect:(CGRect)rect target:(id)target action:(SEL)action{
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:rect];
    [switcher addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    switcher.tintColor = rgba(231, 198, 128, 1);
    switcher.onTintColor = rgba(231, 198, 128, 1);
    switcher.layer.cornerRadius = 16.0;
    switcher.backgroundColor = rgba(231, 198, 128, 1);
    [localView addSubview:switcher];
    return switcher;
    
}
+ (UILabel*) createLabelWithRect:(CGRect)rect title:(NSString*)title{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = title;
    
    label.textColor = rgba(153, 153, 153, 1);
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.textAlignment = UITextAlignmentCenter;
    //    label.tag = 10;
    //    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"GothamPro" size:14.0];
    //    label.hidden = NO;
    //    label.highlighted = YES;
    //    label.highlightedTextColor = [UIColor blueColor];
    //    label.lineBreakMode = YES;
    //    label.numberOfLines = 0;
    
    [localView addSubview:label];
    return label;
}
+ (UITextField*) createTextFieldWithRect:(CGRect)rect title:(NSString*)title placeHolderText:(NSString*)placeHolderText{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    [localView addSubview:textField];
    textField.text = title;
    textField.placeholder = placeHolderText;   //for place holder
    //    textField.textAlignment = UITextAlignmentLeft;          //for text Alignment
    //    textField.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0]; // text font
    //    textField.adjustsFontSizeToFitWidth = YES;     //adjust the font size to fit width.
    //
    textField.textColor = rgba(78, 60, 54, 1);             //text color
    //    textField.keyboardType = UIKeyboardTypeAlphabet;        //keyboard type of ur choice
    //    textField.returnKeyType = UIReturnKeyDone;              //returnKey type for keyboard
    //    textField.clearButtonMode = UITextFieldViewModeWhileEditing;//for clear button on right side
    //
    //    textField.delegate = self;
    
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}
+ (UIImageView*) createImageViewWithRect:(CGRect)rect image:(UIImage*)image{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.image = image;
    [localView addSubview:imageView];
    return imageView;
}
+ (UIButton*)createButtonInRect:(CGRect)rect title:(NSString*)title target:(id)target action:(SEL)action backGroundImage:(UIImage*)backgroundImage highlightImage:(UIImage*)highlightImage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//UIButtonTypeRoundedRect
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = rect;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    // Pressed state background
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    //invisible is a selector see below
    [localView addSubview:button];
    return button;
}
+ (UITextView*) createTextViewWithRect:(CGRect)rect contentText:(NSString*)text{
    
    UITextView* textView = [[UITextView alloc]initWithFrame:rect];
    //    textView.font = [UIFont fontWithName:@"Helvetica" size:12];
    //    textView.font = [UIFont boldSystemFontOfSize:12];
    //    textView.backgroundColor = [UIColor whiteColor];
    textView.scrollEnabled = YES;
    textView.pagingEnabled = YES;
    textView.editable = YES;
    textView.text = text;
    //    textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lines.png"]];
    //    [textView becomeFirstResponder];
    [localView addSubview:textView];
    return textView;
}
+ (CGSize) getScreenBounds{
    NSLog(@"%@",NSStringFromCGSize([UIScreen mainScreen].bounds.size));
    return [UIScreen mainScreen].bounds.size;
}

+ (CGSize)getTextBoundsSize:(NSString*)text font:(UIFont*)font{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize textSize = [text sizeWithAttributes:attributes];
    return textSize;
}

+ (UIView *)viewToAddOn {
    
    return localView;
}
+(void)setViewToAddOn:(UIView *)view{
    if (view != localView) {
        localView = view;
    }
}



+ (void) deleteFolderAtPath:(NSString*) fileName inDocumentsDirectory:(BOOL)inDocDir{
    
    NSFileManager *filemgr;
    NSString *docsDir;
    NSString *newDir;
    
    filemgr =[NSFileManager defaultManager];
    
    if (inDocDir) {
        docsDir = [Utils applicationDocumentsDirectory];
    }else{
        docsDir = @"";
    }
    newDir = [NSString stringWithFormat:@"%@/%@",docsDir,fileName];
    if ([filemgr removeItemAtPath: newDir error: nil] == NO)
    {
        // Directory removal failed.
        NSLog(@"ERROR DELETING FOLDER");
    }else{
        NSLog(@"YOUR RENTAL PERIOD IS EXPIRED. THE BOOK IS DELETED.");
    }
}

/*Function Name : applicationDocumentsDirectory
 *Return Type   : NSString - Returns the path to documents directory
 *Parameters    : nil
 *Purpose       : To find the path to documents directory
 */
+ (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
/*Function Name : unzipAndSaveFile
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To unzip the epub file to documents directory
 */
+ (BOOL)unzipAndSaveFile:(NSString*)fileName atPath:(NSString*)filePath{
    
    ZipArchive* za = [[ZipArchive alloc] init];
    //	NSLog(@"%@", fileName);
    //	NSLog(@"unzipping %@", epubFilePath);
    NSString *absoluteFile = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
    if( [za UnzipOpenFile:absoluteFile]){
        //Delete all the previous files
        if (![[absoluteFile lastPathComponent] hasSuffix:@".epub"]) {
            NSFileManager *filemanager=[[NSFileManager alloc] init];
            if ([filemanager fileExistsAtPath:absoluteFile]) {
                NSError *error;
                [filemanager removeItemAtPath:absoluteFile error:&error];
            }
            filemanager=nil;
        }
        //start unzip
        BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",[absoluteFile stringByDeletingPathExtension]] overWrite:NO];
        if( NO==ret ){
            // error handler here
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Error while unzipping the epub"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
            [za UnzipCloseFile];
            return NO;
        }else if (YES == ret){
            [za UnzipCloseFile];
            return YES;
        }
    }
    return NO;
}


@end
