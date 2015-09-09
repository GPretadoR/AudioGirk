//
//  SandboxReceiptValidationStore.m
//  ChinesePod
//
//  For testing in sandbox mode
//  Created by Yi Zeng on 5/7/14.
//

#import "SandboxReceiptValidationStore.h"

#define SHARED_SECRET @"14a67219bd6447239a7909b3ad34e8d5"

@implementation SandboxReceiptValidationStore
// this returns an NSDictionary of the app's store receipt, status=0 for good, -1 for bad

- (BOOL) successfullyVerified{
    BOOL success = FALSE;
    NSDictionary *receiptDict = [self getStoreReceipt:YES];
    if ([receiptDict[@"status"] intValue] == 0) {
        success = TRUE;
    }
    return success;
}

- (NSDictionary *) getStoreReceipt:(BOOL)sandbox {
    
    NSArray *objects;
    NSArray *keys;
    NSDictionary *dictionary;
    
    BOOL gotreceipt = false;
    
    @try {
        
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]]) {
            
            NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
            
            NSString *receiptString = [self base64forData:receiptData];
            
            if (receiptString != nil) {
                
                objects = @[receiptString, SHARED_SECRET];
                keys = @[@"receipt-data", @"password"];
                dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                
                NSError *error = nil;
                NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
                NSString *postString = @"";
                if (! postData)
                {
                    NSLog(@"Got an error: %@", error);
                }
                else {
                    postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                }
                
                NSString *urlSting = @"https://buy.itunes.apple.com/verifyReceipt";
                if (sandbox) urlSting = @"https://sandbox.itunes.apple.com/verifyReceipt";
                
                dictionary = [self getJsonDictionaryWithPostFromUrlString:urlSting andDataString:postString];
                
                if (dictionary[@"status"] != nil) {
                    
                    if ([dictionary[@"status"] intValue] == 0) {
                        
                        gotreceipt = true;
                        
                    }
                }
                
            }
            
        }
        
    } @catch (NSException * e) {
        gotreceipt = false;
    }
    
    if (!gotreceipt) {
        objects = @[@"-1"];
        keys = @[@"status"];
        dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    }
    
    return dictionary;
}



- (NSDictionary *) getJsonDictionaryWithPostFromUrlString:(NSString *)urlString andDataString:(NSString *)dataString {
    NSString *jsonString = [self getStringWithPostFromUrlString:urlString andDataString:dataString];
//    NSLog(@"JSON string: %@", jsonString); // see what the response looks like
    return [self getDictionaryFromJsonString:jsonString];
}


- (NSDictionary *) getDictionaryFromJsonString:(NSString *)jsonstring {
    NSError *jsonError;
    NSDictionary *dictionary = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:[jsonstring dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonError];
    if (jsonError) {
        dictionary = [[NSDictionary alloc] init];
    }
    return dictionary;
}


- (NSString *) getStringWithPostFromUrlString:(NSString *)urlString andDataString:(NSString *)dataString {
    NSString *s = @"";
    @try {
        NSData *postdata = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postlength = [NSString stringWithFormat:@"%lu", [postdata length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        [request setValue:postlength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postdata];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data != nil) {
            s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception is caught: %@", exception.reason);
        s = @"";
    }
    return s;
}


// from http://stackoverflow.com/questions/2197362/converting-nsdata-to-base64
- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
@end
