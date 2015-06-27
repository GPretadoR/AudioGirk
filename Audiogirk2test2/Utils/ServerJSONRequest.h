//
//  ServerJSONRequest.h
//  Audiogirk2test2
//
//  Created by Garnik Ghazaryan on 2/23/15.
//  Copyright (c) 2015 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerJSONRequest : NSObject <NSURLConnectionDelegate> {

    void (^completionBlock)(BOOL);
}


- (void) checkInternetConnection:(void (^)(BOOL isReachable))compBlock;
@end
