//
//  CXMLNode.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/07/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#include <libxml/tree.h>

typedef NS_ENUM(unsigned int, CXMLNodeKind) {
	CXMLInvalidKind = 0,
	CXMLElementKind = XML_ELEMENT_NODE,
	CXMLAttributeKind = XML_ATTRIBUTE_NODE,
	CXMLTextKind = XML_TEXT_NODE,
	CXMLProcessingInstructionKind = XML_PI_NODE,
	CXMLCommentKind = XML_COMMENT_NODE,
	CXMLNotationDeclarationKind = XML_NOTATION_NODE,
	CXMLDTDKind = XML_DTD_NODE,
	CXMLElementDeclarationKind =  XML_ELEMENT_DECL,
	CXMLAttributeDeclarationKind =  XML_ATTRIBUTE_DECL,
	CXMLEntityDeclarationKind = XML_ENTITY_DECL,
	CXMLNamespaceKind = XML_NAMESPACE_DECL,
};

@class CXMLDocument;

// NSXMLNode
@interface CXMLNode : NSObject <NSCopying> {
	xmlNodePtr _node;
	BOOL _freeNodeOnRelease;
}

@property (NS_NONATOMIC_IOSONLY, readonly) CXMLNodeKind kind;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *stringValue;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger index;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger level;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) CXMLDocument *rootDocument;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) CXMLNode *parent;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger childCount;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *children;
- (CXMLNode *)childAtIndex:(NSUInteger)index;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) CXMLNode *previousSibling;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) CXMLNode *nextSibling;
//- (CXMLNode *)previousNode;
//- (CXMLNode *)nextNode;
//- (NSString *)XPath;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *localName;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *prefix;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *URI;
+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;
+ (CXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *description;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;
- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;
@end
