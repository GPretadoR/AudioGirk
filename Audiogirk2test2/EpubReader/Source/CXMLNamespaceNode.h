//
//  CXMLNamespaceNode.h
//  TouchXML
//

#import <Foundation/Foundation.h>
#import "CXMLNode.h"
#import "CXMLElement.h"

@interface CXMLNamespaceNode : CXMLNode {

	NSString *_prefix;
	NSString *_uri;
	CXMLElement *_parent;
}

- (instancetype) initWithPrefix:(NSString *)prefix URI:(NSString *)uri parentElement:(CXMLElement *)parent NS_DESIGNATED_INITIALIZER;

@end
