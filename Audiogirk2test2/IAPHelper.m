//
//  IAPHelper.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 6/13/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "IAPHelper.h"
#import "VerificationController.h"

// Declaration of a notification we'll use to notify listeners when a product has been purchased
NSString *const IAPHelperProductPurchasedNotification;

@implementation IAPHelper {

    /*
     You create an instance variable to store the SKProductsRequest you will issue to retrieve a list of products, while it is active.
     */
    NSMutableSet * _purchasedProductIdentifiers;
}

- (void)rentProductWithIdentifier:(NSString *) productIdentifier{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
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
#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
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
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed to load list of products."
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    NSLog(@"Failed to load list of products.");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
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

// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Rent successfully!"
                                                      message:@"Thank you for your purchase. Enjoy!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    [self validateReceiptForTransaction:transaction];

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// called when a transaction has been restored and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Restored successfully!"
                                                      message:@"Enjoy!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    [self validateReceiptForTransaction:transaction];
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
    
    [_purchasedProductIdentifiers addObject:productIdentifier];

    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification
                                                        object:productIdentifier
                                                      userInfo:nil];
}


- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {
    VerificationController * verifier = [VerificationController sharedInstance];
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Successfully verified receipt!");
            [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
        } else {
            NSLog(@"Failed to validate receipt.");
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }];
}


@end
