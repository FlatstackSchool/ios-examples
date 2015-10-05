//
//  XMLReader.m
//
//  Created by Vladimir Goncharov on 23.08.15.
//  Copyright (c) 2015 FlatStack. All rights reserved.
//

#import "XMLReader.h"


#pragma mark - XMLReader

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "XMLReader requires ARC support."
#endif

NSString *const kXMLReaderTextNodeKey		= @"__XMLReaderValue__";
NSString *const kXMLReaderAttributePrefix	= @"@";

@interface XMLReader ()

@property (nonatomic, strong) NSMutableArray *dictionaryStack;
@property (nonatomic, strong) NSMutableString *textInProgress;
@property (nonatomic, strong) NSError *errorPointer;

@end


@implementation XMLReader

#pragma mark - Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    XMLReader *reader = [[XMLReader alloc] initWithError:error];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSDictionary *rootDictionary = [reader objectWithNSXMLParser:parser options:0];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XMLReaderOptions)options error:(NSError **)error
{
    XMLReader *reader = [[XMLReader alloc] initWithError:error];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSDictionary *rootDictionary = [reader objectWithNSXMLParser:parser options:options];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLReader dictionaryForXMLData:data error:error];
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XMLReaderOptions)options error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLReader dictionaryForXMLData:data options:options error:error];
}

+ (NSDictionary *)dictionaryForNSXMLParser:(NSXMLParser *)xmlParser error:(NSError **)error
{
    return [XMLReader dictionaryForNSXMLParser:xmlParser options:0 error:error];
}

+ (NSDictionary *)dictionaryForNSXMLParser:(NSXMLParser *)xmlParser options:(XMLReaderOptions)options error:(NSError **)error
{
    XMLReader *reader = [[XMLReader alloc] initWithError:error];
    NSDictionary *rootDictionary = [reader objectWithNSXMLParser:xmlParser options:options];
    return rootDictionary;
}


#pragma mark - Parsing

- (id)initWithError:(NSError **)error
{
    self = [super init];
    if (self)
    {
        self.errorPointer = *error;
    }
    return self;
}

- (NSDictionary *)objectWithNSXMLParser:(NSXMLParser *)xmlParser options:(XMLReaderOptions)options
{
    // Clear out any old data
    self.dictionaryStack = [[NSMutableArray alloc] init];
    self.textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [self.dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    [xmlParser setShouldProcessNamespaces:(options & XMLReaderOptionsProcessNamespaces)];
    [xmlParser setShouldReportNamespacePrefixes:(options & XMLReaderOptionsReportNamespacePrefixes)];
    [xmlParser setShouldResolveExternalEntities:(options & XMLReaderOptionsResolveExternalEntities)];
    
    xmlParser.delegate = self;
    BOOL success = [xmlParser parse];
    
    // Return the stack's root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [self.dictionaryStack objectAtIndex:0];
        resultDict = [XMLReader prepareResultDict:resultDict];
        return resultDict;
    }
    
    return nil;
}

#pragma mark - Update result

+ (NSDictionary *)prepareResultDict:(NSDictionary *)resultDict
{
    NSMutableDictionary *mResultDict = [resultDict mutableCopy];
    [self updateNode:mResultDict];
    return [mResultDict copy];
}

+ (void)updateNode:(NSMutableDictionary *)node
{
    for (NSString *key in [node allKeys]) {
        id value = node[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dictValue = value;
            NSArray *dictKeys = [dictValue allKeys];
            for (NSString *dictKey in dictKeys) {
                if ([dictKey isEqualToString:kXMLReaderTextNodeKey]) {
                    node[key] = dictValue[dictKey];
                } else {
                    if ([XMLReader updateArrayNode:dictValue key:dictKey] == false) {
                        [self updateNode:value];
                    }
                }
            }
        }
    }
}

+ (BOOL)updateArrayNode:(NSMutableDictionary *)node
                    key:(NSString *)key
{
    id nodeValue  = node[key];
    if ([nodeValue isKindOfClass:[NSArray class]]) {
        
        NSArray *currentValueAsArray = nodeValue;
        NSMutableArray *updatedCurrentValue = [[NSMutableArray alloc] init];
        
        for (id currentObject in currentValueAsArray) {
            if ([currentObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *currentDictionary = currentObject;
                id currentValue = currentDictionary[kXMLReaderTextNodeKey];
                [updatedCurrentValue addObject:currentValue];
            } else {
                [updatedCurrentValue addObject:currentObject];
            }
        }
        
        node[key] = updatedCurrentValue;
        
        return true;
    }
    
    return false;
}

+ (id)prepareCharacters:(NSString *)string
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) {
        return string;
    } else {
        return @([string doubleValue]);
    }
}

#pragma mark -  NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [self.dictionaryStack lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [self.dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [self.dictionaryStack lastObject];
    
    // Set the text property
    if ([self.textInProgress length] > 0)
    {
        // trim after concatenating
        NSString *trimmedString = [self.textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [dictInProgress setObject:[XMLReader prepareCharacters:trimmedString] forKey:kXMLReaderTextNodeKey];
        
        // Reset the text
        self.textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [self.dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [self.textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    self.errorPointer = parseError;
}

@end



#pragma mark - FSXMLResponseSerializer

#ifndef AFNetworking

@implementation FSXMLResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithXMLReaderOptions:0];
}

+ (instancetype)serializerWithXMLReaderOptions:(XMLReaderOptions)options {
    FSXMLResponseSerializer *serializer = [[self alloc] init];
    serializer.options = options;
    
    return serializer;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    if (responseObject && [responseObject isMemberOfClass:[NSXMLParser class]]) {
        return [XMLReader dictionaryForNSXMLParser:responseObject options:self.options error:error];
    }
    
    return nil;
}

#pragma mark - NSSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    self.options = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(options))] unsignedIntegerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:@(self.options) forKey:NSStringFromSelector(@selector(options))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    FSXMLResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.options = self.options;
    
    return serializer;
}

@end

#endif