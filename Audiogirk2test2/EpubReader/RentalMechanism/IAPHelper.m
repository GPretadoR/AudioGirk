//
//  IAPHelper.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/13/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "IAPHelper.h"

#import "RentalLogicManager.h"
#import "SandboxReceiptValidationStore.h"
#import "SVProgressHUD.h"

BookItemsObject* bookItemObject;
// Declaration of a notification we'll use to notify listeners when a product has been purchased
NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@implementation IAPHelper {

    /*
     You create an instance variable to store the SKProductsRequest you will issue to retrieve a list of products, while it is active.
     */
    NSMutableSet * _purchasedProductIdentifiers;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)rentProductWithIdentifier:(NSString *) productIdentifier{
    
//    TODO: Remove This line
    [RentalLogicManager checkUpdateOrDownload:bookItemObject];
    return;
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        [SVProgressHUD showWithStatus:@"Please Wait..."];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User cannot make payments probably due to parental controls" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restoreCompletedTransactions
{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
#pragma mark BookItemsObject set get
+ (BookItemsObject*) getBookItemsObject{
    return bookItemObject;
}

+ (void)setBookItemsObject:(BookItemsObject*) theBookItemObject {
    if (theBookItemObject != bookItemObject) {
        bookItemObject = theBookItemObject;
    }
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if(count > 0){
        validProduct = (response.products)[0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list of products.");
    [SVProgressHUD showErrorWithStatus:@"Failed to load list of products."];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [SVProgressHUD dismiss];
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    if (queue.transactions.count == 0)
    {
        //No item found for Restore"
        [SVProgressHUD showWithStatus:@"No items to restore"];
    }
    else
    {
        // Restore items
        for (int i = 0; i < queue.transactions.count; i++) {
            [self performSelectorOnMainThread:@selector(restoreCompletedTransactions) withObject:queue.transactions[i] waitUntilDone:YES];
        }
     
    }
    
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error restoring /n %@", [error localizedDescription]]];
}
// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    [self validateReceiptForTransaction:transaction isSuccess:[[[SandboxReceiptValidationStore alloc] init] successfullyVerified]];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// called when a transaction has been restored and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");

    [self validateReceiptForTransaction:transaction isSuccess:[[[SandboxReceiptValidationStore alloc] init] successfullyVerified]];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                          message:transaction.error.localizedDescription
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


#pragma mark other IAP Related methods
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    NSLog(@"provideContentForProductIdentifier");
    
    [RentalLogicManager checkUpdateOrDownload:bookItemObject];

    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification
                                                        object:productIdentifier
                                                      userInfo:nil];
}


- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction isSuccess:(BOOL) success {

    if (success){
        [SVProgressHUD showSuccessWithStatus:@"Successfully Completed!"];
        [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Failed to validate receipt"];
        NSLog(@"Failed to validate receipt.");
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }


}


@end
