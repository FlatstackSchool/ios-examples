#import <UIKit/UIKit.h>
#import "XMLReader.h"

@class SOAPRequest;

//TODO: - it works wrong and need change
//https://developer.apple.com/library/mac/documentation/Networking/Conceptual/UsingWebservices/Tasks/Tasks.html#//apple_ref/doc/uid/TP30000985-CH101-SW3

#pragma mark - SOAPRequest

enum {SOAPRequestPercentUnknown = NSNotFound};

typedef void (^SOAPCompletionHandler)(NSURLResponse *response, NSData *data, NSError *error);
typedef void (^SOAPDownloadingHandler)(NSURLResponse *response, CGFloat percent);

@protocol SOAPRequestDelegate <NSObject>
@optional
- (void)soapRequestDownloading:(SOAPRequest *)soap
                       percent:(CGFloat)percent;

- (void)soapRequestDownloadFinish:(SOAPRequest *)soap
                             data:(NSData *)data;
- (void)soapRequestDownloadFail:(SOAPRequest *)soap
                           error:(NSError *)error;
@end

@interface SOAPRequest : NSObject <NSObject, NSCopying, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <SOAPRequestDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) SOAPCompletionHandler completionHandler;
@property (nonatomic, copy) SOAPDownloadingHandler downloadingHandler;

- (id)initWithURL:(NSURL *)url
           action:(NSString *)action;

- (void)addHeaderField:(NSString *)field
                 value:(NSString *)value;
- (void)addMethod:(NSString *)name
           params:(NSDictionary *)params;

- (NSURLRequest *)resultRequest;

- (void)startWithNetworkActivityIndicatorVisible:(BOOL)indicatorVisible;
- (void)cancel;

@end

@interface SOAPRequest (Unavailable)

- (id)init __attribute__((unavailable("init not available! Use initWithURL:")));

@end




#ifndef AFNetworking

#import "AFHTTPRequestOperationManager.h"

#pragma mark - SOAP request

@interface SOAPParameter : NSObject <NSCoding, NSSecureCoding, NSCopying>

@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *parameters;

+ (instancetype)parameterWithMethod:(NSString *)method
                         parameters:(NSDictionary *)parameters;

@end

@interface SOAPParameter (Unavailable)

- (id)init __attribute__((unavailable("init not available!")));

@end

@interface AFHTTPRequestOperationManager (SOAP)

/**
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer. Must containt array of SOAPParameter.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 */
- (AFHTTPRequestOperation *)SOAP:(NSString *)URLString
                     parameters:(NSArray *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end



#pragma mark - FSSOAPRequestSerializer

#import "AFURLRequestSerialization.h"

/**
 `FSSOAPRequestSerializer` is a subclass of `AFHTTPRequestSerializer` that encodes parameters as SOAP using `SOAPRequest`, setting the `Content-Type` of the encoded request to `application/soap+xml`.
 */
@interface FSSOAPRequestSerializer : AFHTTPRequestSerializer

@end


#endif