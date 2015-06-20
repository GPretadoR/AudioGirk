//
//  SandboxReceiptValidationStore.h
//  ChinesePod
//
//  Created by Yi Zeng on 5/7/14.
//

#import <Foundation/Foundation.h>

@interface SandboxReceiptValidationStore : NSObject

- (NSDictionary *)getStoreReceipt:(BOOL)sandbox;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL successfullyVerified;

- (NSString*)base64forData:(NSData*)theData;
@end
