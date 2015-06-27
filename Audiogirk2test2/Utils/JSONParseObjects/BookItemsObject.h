//
//  BookItemsObject.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 9/30/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "JSONModel.h"

@protocol BookItemsObject
@end

@interface BookItemsObject : JSONModel

@property (strong, nonatomic) NSString *b_author;
@property (strong, nonatomic) NSString *b_desc;
@property (strong, nonatomic) NSString *b_image;
@property (strong, nonatomic) NSString *b_name;
//@property (nonatomic)         int       b_duration;
@property (strong, nonatomic) NSString *b_edition;
@property (strong, nonatomic) NSString *b_lang;
@property (strong, nonatomic) NSString *b_pub_year;
@property (strong, nonatomic) NSString *b_publisher;
//@property (nonatomic)         int       b_size;
@property (nonatomic)         int       b_type_id;
@property (strong, nonatomic) NSString *category_name;
@property (strong, nonatomic) NSString *format;
@property (nonatomic)         NSString *id;
@property (nonatomic)         BOOL      isFiction;
@property (strong, nonatomic) NSString *narrator_sex;
@property (nonatomic)         BOOL      isBanner;
//@property (strong, nonatomic) NSString *b_text;
//@property (strong, nonatomic) NSString *b_sample_audio;
//@property (strong, nonatomic) NSString *b_sample_text;

@end
