#import "SOAPRequest.h"

#define END_HEADER  @"</SOAP-ENV:Header>"
#define END_BODY    @"</SOAP-ENV:Body>"

static NSString *const kHTTPHeaderFieldAction = @"SOAPAction";

static inline NSString *getSOAPBodyPrototype()
{
    NSString *result = @"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns0=\"urn:xmethods-delayed-quotes\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Header></SOAP-ENV:Header><SOAP-ENV:Body></SOAP-ENV:Body></SOAP-ENV:Envelope>";
    return result;
}

static inline NSString *concatStringXMLStyle(NSString *key, NSString *value)
{
    return [NSString stringWithFormat:@"<%@>%@</%@>\r\n", key, value, key];
}

static inline NSString *makeSOAPMethod(NSString *name, NSString *params)
{
    return [NSString stringWithFormat:@"<ns0:%@ SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\r\n%@</ns0:%@>", name, params, name];
}

@interface SOAPRequest ()

@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSMutableString *body;

@property (nonatomic, assign) BOOL isVisibleNetworkIndicator;

@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;

@end

@implementation SOAPRequest

#pragma mark - initialization

- (id)initWithURL:(NSURL *)url
           action:(NSString *)action
{
    self = [super init];
    if (self)
    {
        self.isVisibleNetworkIndicator = NO;
        self.body = [getSOAPBodyPrototype() mutableCopy];
        
        self.request = [[NSMutableURLRequest alloc] initWithURL:url
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:30.0f];

        [self.request setHTTPMethod:@"POST"];
        if (action) {
            [self.request addValue:[NSString stringWithFormat: @"\"%@\"", action]
                forHTTPHeaderField:kHTTPHeaderFieldAction];
        }
        [self.request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
        [self.request setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    }
    return self;
}

- (NSURLRequest *)resultRequest
{
    NSMutableURLRequest *request = [self.request mutableCopy];
    NSData *body = [self.body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    return [request copy];
}

#pragma mark - <NSObject>

- (NSString *)description
{
    NSMutableString *result = [NSMutableString new];
    [result appendString:@"\r\n"];
    [result appendString:[NSString stringWithFormat:@"<%@>delegate - %@ \"%@\"", self, self.delegate, self.request.URL]];
    [result appendString:[NSString stringWithFormat:@"tag - %li\r\n", (long)self.tag]];
    [result appendString:[NSString stringWithFormat:@"%@\r\n", self.body]];
    return [result copy];
}

- (NSString *)debugDescription
{
	return [self description];
}

#pragma mark - <NSMutableCopying>

- (id)copyWithZone:(NSZone *)zone
{
	SOAPRequest *object = [[SOAPRequest allocWithZone:zone] initWithURL:[self.request.URL copy]
                                                                 action:[self.request valueForHTTPHeaderField:kHTTPHeaderFieldAction]];
    object.request = [self.request copy];

	return object;
}

#pragma mark - <NSURLConnectionDataDelegate> && uploading

- (void)startWithNetworkActivityIndicatorVisible:(BOOL)indicatorVisible
{
    NSData *body = [self.body dataUsingEncoding:NSUTF8StringEncoding];
    [self.request setHTTPBody:body];
    
    self.isVisibleNetworkIndicator = indicatorVisible;
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                      delegate:self
                                              startImmediately:YES];

    if (self.isVisibleNetworkIndicator)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    self.receivedData = [NSMutableData data];
}

- (void)cancel
{
    [self.connection cancel];
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)aResponse
{
    self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
    
    CGFloat expectedLength = [self.response expectedContentLength];
    CGFloat percent = NSNotFound;
    if (expectedLength >= 0)
    {
        CGFloat currentLength = [self.receivedData length];
        percent = currentLength / expectedLength;
    }
    
    if ([self.delegate respondsToSelector:@selector(soapRequestDownloading:percent:)])
    {
        [self.delegate soapRequestDownloading:self
                                      percent:percent];
    }
    
    if (self.downloadingHandler)
    {
        self.downloadingHandler(self.response, percent);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSData *data = [self.receivedData copy];
    
    if ([self.delegate respondsToSelector:@selector(soapRequestDownloadFinish:data:)])
    {
        [self.delegate soapRequestDownloadFinish:self
                                            data:data];
    }
    
    if (self.completionHandler)
    {
        self.completionHandler(self.response, data, nil);
    }
    
    [self _clearSession];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([self.delegate respondsToSelector:@selector(soapRequestDownloadFail:error:)])
    {
        [self.delegate soapRequestDownloadFail:self
                                         error:error];
    }

    if (self.completionHandler)
    {
        self.completionHandler(self.response, nil, error);
    }
    
    [self _clearSession];
}

- (void)_clearSession
{
    self.receivedData = nil;
    self.response = nil;
    self.connection = nil;
}

#pragma mark - adding params

- (void)addHeaderField:(NSString *)field
                 value:(NSString *)value
{
    NSRange range = [self.body rangeOfString:END_HEADER];
    NSString *headerValue = concatStringXMLStyle(field, value);
    [self.body insertString:headerValue
                    atIndex:range.location];
}

- (void)addMethod:(NSString *)name
           params:(NSDictionary *)params
{
    NSRange range = [self.body rangeOfString:END_BODY];
    
    NSMutableString *concatParams = [[NSMutableString alloc] initWithString:@""];
    
    for (NSString *key in params)
    {
        NSString *value = [params valueForKey:key];

        [concatParams appendString:concatStringXMLStyle(key, value)];
    }
    
    NSString *method = makeSOAPMethod(name, [concatParams copy]);
    
    [self.body insertString:method
                    atIndex:range.location];
}

@end



@implementation SOAPParameter

+ (instancetype)parameterWithMethod:(NSString *)method
                         parameters:(NSDictionary *)parameters {
    
    SOAPParameter *soapParameter = [super init];
    soapParameter->_method = method;
    soapParameter->_parameters = parameters;
    return soapParameter;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _method = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(method))];
    _parameters = [decoder decodeObjectOfClass:[NSDictionary class] forKey:NSStringFromSelector(@selector(parameters))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.method forKey:NSStringFromSelector(@selector(method))];
    [coder encodeObject:self.parameters forKey:NSStringFromSelector(@selector(parameters))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    SOAPParameter *soapParameter = [[[self class] allocWithZone:zone] init];
    soapParameter->_method = self.method;
    soapParameter->_parameters = self.parameters;
    
    return soapParameter;
}

@end

@implementation AFHTTPRequestOperationManager (SOAP)

/**
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer. Must containt array of SOAPParameter.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 */
- (AFHTTPRequestOperation *)SOAP:(NSString *)URLString
                      parameters:(NSArray *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
//    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithHTTPMethod:@"GET" URLString:URLString parameters:parameters success:success failure:failure];
//    
//    [self.operationQueue addOperation:operation];
//    
//    return operation;
    return nil;
    
}

@end


#pragma mark - FSSOAPRequestSerializer

@implementation FSSOAPRequestSerializer

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    SOAPRequest *soapRequest = [[SOAPRequest alloc] initWithURL:request.URL
                              action:nil];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        id valueForHTTPHeaderField = [request valueForHTTPHeaderField:field];
        if (!valueForHTTPHeaderField) {
            [soapRequest addHeaderField:field
                                  value:value];
        } else {
            [soapRequest addHeaderField:field
                                  value:valueForHTTPHeaderField];
        }
    }];
    
    for (SOAPParameter *soapParameter in parameters) {
        NSAssert([soapParameter isKindOfClass:[SOAPParameter class]], @"Parameters must be as a array of SOAPParameter");
        [soapRequest addMethod:soapParameter.method
                        params:soapParameter.parameters];
    }
    
    return [soapRequest resultRequest];
}

@end

