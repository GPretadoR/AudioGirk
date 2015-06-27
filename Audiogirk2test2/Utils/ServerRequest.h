//
//  ServerRequest.h

#import <Foundation/Foundation.h>

@interface ServerRequest : NSObject {
    NSMutableData *responseData;
    NSURLConnection *urlConnection;
    void (^completionBlock)(NSArray *);
    
    NSMutableArray *responseArray;
}

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *urlConnection;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)getWithUrlString:(NSString *)urlString completion:(void (^)(NSArray *items))completionBlock;
- (void)postWithUrlString:(NSString *)urlString completion:(void (^)(NSArray *result))completionBlock;
- (void)postWithUrlString:(NSString *)urlString andBody:(NSData*)body completion:(void (^)(NSArray *result))cb;
- (void)cancel;

//Wrapped methods decl
- (NSMutableArray*)getWithUrlString:(NSString *)urlString;

@end
