//
//  Sec.m


#import "Sec.h"
#import "NSString+MD5.h"
#import "NSString+urlencode.h"
#import "Base64.h"
#include <stdlib.h>
#include <CommonCrypto/CommonDigest.h>
@implementation Sec

NSString *secret=@",O3?}C6P<F19sY#z";

+ (NSString *)getKey {
    NSString *key = @"vahan.karen.levon.ttteam";
    int r = arc4random() % 9999999;
    NSString *rstring = [NSString stringWithFormat:@"%d", r];
    NSString *md5rand = [rstring MD5];
    NSString *md5key = [key MD5];

    NSMutableString *mstring = [[NSMutableString alloc] initWithCapacity:64];
    for (int i = 0; i < md5key.length; ++i) {
        unichar b = [md5key characterAtIndex:i];
        [mstring appendString:[NSString stringWithCharacters:&b length:1]];
        if ( i % 2 == 0 && i > 0 ) {
            unichar br = [md5rand characterAtIndex:i];
            [mstring appendString:[NSString stringWithCharacters:&br length:1]];
        }
    }
    
    return mstring;
}

+ (NSString *)getUrlForParams:(NSDictionary *)params {
    NSMutableString *url = [[NSMutableString alloc] initWithCapacity:15];
    
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        if (url.length > 0) {
            [url appendString:@"&"];
        }
        
        [url appendString:[NSString stringWithFormat:@"%@=%@", [key urlencode], [value urlencode]]];
    }
   
    return [url base64EncodedString];
}

+(NSString *)stringToSha1:(NSString *)str{
    const char *s = [str cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    // description converts to hex but puts <> around it and spaces every 4 bytes
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
//    NSLog(@"Hash is %@ for string %@", hash, str);
    
    return hash;
}
+ (NSString*) createKey{
    
    NSString *hashedString = @"";
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    UUID = [UUID lowercaseString];
    UUID = [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *hashedSecret = [Sec stringToSha1:secret];
    hashedString = [Sec stringToSha1:[NSString stringWithFormat:@"%@%@",hashedSecret,UUID]];
    hashedString = [hashedString stringByAppendingString:UUID];
    hashedString = [hashedString lowercaseString];
    hashedString = [hashedString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return  hashedString;
}

@end
