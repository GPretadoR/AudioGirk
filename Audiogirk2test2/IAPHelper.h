//
//  IAPHelper.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/13/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "BookItemsModel.h"

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@interface IAPHelper : NSObject  <SKProductsRequestDelegate, SKPaymentTransactionObserver>

// Method definition
// Method to start buying a product
- (void)rentProductWithIdentifier:(NSString *) productIdentifier;
// Method to restore completed transactions
- (void)restoreCompletedTransactions;

//Book Items object to download the book
+ (BookItemsObject*) getBookItemsObject;
+ (void)setBookItemsObject:(BookItemsObject*) bookItemObject;
@end
