//
//  CXMLNamespaceNode.m
//  TouchXML
//

#import "CXMLNamespaceNode.h"

@implementation CXMLNamespaceNode

#pragma mark -
#pragma mark Init and dealloc

- (instancetype) initWithPrefix:(NSString *)prefix URI:(NSString *)uri parentElement:(CXMLElement *)parent
{
	if ((self = [super init]) != NULL) 
	{
		_prefix = [prefix copy];
		_uri = [uri copy];
		_parent = parent; // Don't retain parent
	}
	
	return self;
}



#pragma mark -
#pragma mark Overidden methods

// NB: We need to override every method that relies on _node as namespaces in libXML don't have a xmlNode 

- (CXMLNodeKind)kind
{
	return CXMLNamespaceKind;
}

- (NSString *)name
{
	return _prefix ? [_prefix copy] : @"";
}

- (NSString *)stringValue
{
	return _uri ? [_uri copy] : @"";
}

- (NSUInteger)index
{
	return 0; // TODO: Write tets, Fix
}

- (NSUInteger)level
{
	return _parent ? [_parent level] + 1 : 2;
}

- (CXMLDocument *)rootDocument
{
	return [_parent rootDocument];
}

- (CXMLNode *)parent
{
	return _parent;
}

- (NSUInteger)childCount
{
	return 0;
}

- (NSArray *)children
{
	return nil;
}

- (CXMLNode *)childAtIndex:(NSUInteger)index
{
	return nil;
}

- (CXMLNode *)previousSibling
{
	return nil; // TODO: Write tets, Fix
}

- (CXMLNode *)nextSibling
{
	return nil; // TODO: Write tets, Fix
}

//- (CXMLNode *)previousNode;
//- (CXMLNode *)nextNode;
//- (NSString *)XPath;

- (NSString *)localName
{
	return [self name];
}

- (NSString *)prefix
{
	return @"";
}

- (NSString *)URI
{
	return nil;
}

//+ (NSString *)localNameForName:(NSString *)name;
//+ (NSString *)prefixForName:(NSString *)name;
//+ (CXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;

- (NSString *)description
{
	if (_prefix && [_prefix length] > 0)
		return [NSString stringWithFormat:@"xmlns:%@=\"%@\"", _prefix, _uri];

	return [NSString stringWithFormat:@"xmlns=\"%@\"", _uri];
}

- (NSString *)XMLString
{
	return [self description];
}

- (NSString *)XMLStringWithOptions:(NSUInteger)options
{
	return [self description];
}

//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error
{
	return nil;
}

@end
