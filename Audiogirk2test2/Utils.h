//
//  Utils.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/25/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface Utils : NSObject


+ (UILabel*) createLabelWithRect:(CGRect)rect title:(NSString*)title;
+ (UITextField*) createTextFieldWithRect:(CGRect)rect title:(NSString*)title placeHolderText:(NSString*)placeHolderText;
+ (UIImageView*) createImageViewWithRect:(CGRect)rect image:(UIImage*)image;
+ (UIButton*)createButtonInRect:(CGRect)rect title:(NSString*)title target:(id)target action:(SEL)action backGroundImage:(UIImage*)backgroundImage highlightImage:(UIImage*)highlightImage;
+ (UITextView*) createTextViewWithRect:(CGRect)rect contentText:(NSString*)text;
+ (UISwitch*)createSwitchWithRect:(CGRect)rect target:(id)target action:(SEL)action;

+ (CGSize)getTextBoundsSize:(NSString*)text font:(UIFont*)font;
+ (CGSize) getScreenBounds;


+ (UIView*)viewToAddOn;
+ (void)setViewToAddOn:(UIView*)view;

+ (NSString *)applicationDocumentsDirectory;
+ (void) deleteFolderAtPath:(NSString*) fileName inDocumentsDirectory:(BOOL)inDocDir;
+ (BOOL)unzipAndSaveFile:(NSString*)fileName atPath:(NSString*)filePath;
@end
