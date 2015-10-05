//
//  XMLReader.h
//
//  Created by Vladimir Goncharov on 23.08.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - XMLReader

enum {
    XMLReaderOptionsProcessNamespaces           = 1 << 0, // Specifies whether the receiver reports the namespace and the qualified name of an element.
    XMLReaderOptionsReportNamespacePrefixes     = 1 << 1, // Specifies whether the receiver reports the scope of namespace declarations.
    XMLReaderOptionsResolveExternalEntities     = 1 << 2, // Specifies whether the receiver reports declarations of external entities.
};
typedef NSUInteger XMLReaderOptions;

@interface XMLReader : NSObject <NSXMLParserDelegate>

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XMLReaderOptions)options error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XMLReaderOptions)options error:(NSError **)errorPointer;

+ (NSDictionary *)dictionaryForNSXMLParser:(NSXMLParser *)xmlParser options:(XMLReaderOptions)options error:(NSError **)error;

@end


@interface XMLReader(Deprecated)

- (instancetype)init __attribute__((unavailable("init not available")));

@end




#pragma mark - FSXMLResponseSerializer

#ifndef AFNetworking

#import "AFURLResponseSerialization.h"

@interface FSXMLResponseSerializer : AFXMLParserResponseSerializer

+ (instancetype)serializerWithXMLReaderOptions:(XMLReaderOptions)options;

@property (nonatomic, assign) XMLReaderOptions options;

@end

#endif