//
//  ServerJSONRequest.m
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/23/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import "ServerJSONRequest.h"


@implementation ServerJSONRequest{

    NSURLConnection *urlConnection;
    BOOL isInternetReachable;
}


- (void) checkInternetConnection:(void (^)(BOOL isReachable))compBlock{
    completionBlock = compBlock;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com"]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    isInternetReachable = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    isInternetReachable = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    isInternetReachable = NO;
    completionBlock(isInternetReachable);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isInternetReachable = YES;
    completionBlock(isInternetReachable);
}


@end
