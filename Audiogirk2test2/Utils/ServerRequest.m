//
//  ServerRequest.m



#import "ServerRequest.h"
#import "AFNetworking.h"


@interface ServerRequest () <NSURLConnectionDelegate>

@end

@implementation ServerRequest

@synthesize responseData;
@synthesize urlConnection;

- (instancetype)init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}
-(void)addNumber:(int)number1 withNumber:(int)number2 andCompletionHandler:(void (^)(int result))completionHandler{
    int result = number1 + number2;
    completionHandler(result);
}

+ (void) makePostRequestWithURL:(NSString*) urlString params:(NSDictionary *) params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}

- (void)getWithUrlString:(NSString *)urlString completion:(void (^)(NSArray *items))cb {
    completionBlock = cb;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)postWithUrlString:(NSString *)urlString completion:(void (^)(NSArray *result))cb {
    completionBlock = cb;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)postWithUrlString:(NSString *)urlString andBody:(NSData*)body completion:(void (^)(NSArray *result))cb {
    completionBlock = cb;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel {
    if ( urlConnection == nil ) return;
    [urlConnection cancel];
}
//====================Wrapped Methods Impl===================

- (NSMutableArray*)getWithUrlString:(NSString *)urlString{

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    return  responseArray;
}


#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: &e];
    
    if (e != nil) {
//        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    }
    responseArray=[[NSMutableArray alloc]initWithArray:jsonArray];
    completionBlock(jsonArray);
}

@end
