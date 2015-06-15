//
//  Sec.h


#import <Foundation/Foundation.h>

@interface Sec : NSObject

+ (NSString *)getKey;
+ (NSString *)getUrlForParams:(NSDictionary *)params;
+ (NSString*) createKey;
@end
