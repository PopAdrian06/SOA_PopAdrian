//
//  BaseService.m
//

#import "BaseService.h"

@interface BaseService () <NSURLSessionDelegate>

@end

@implementation BaseService

- (NSURL *)url:(NSURL *)baseURL byAppendingParameters:(NSDictionary *)params {
    NSURLComponents *url = [[NSURLComponents alloc] initWithURL:baseURL resolvingAgainstBaseURL:YES];
    NSMutableArray *queryItems = NSMutableArray.new;
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *name, id value, BOOL *stop) {
        if ([value isKindOfClass:[NSString class]]) {
            value = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        
        [queryItems addObject:[NSURLQueryItem queryItemWithName:name
                                                          value:value]];
    }];
    url.queryItems = queryItems;
    
    return url.URL;
}

- (void)sendRequestWithBaseURLString:(NSString *)baseURLString
                            endpoint:(NSString *)endpoint
                       requestMethod:(RequestMethod)method
                              params:(NSDictionary *)params
                         requestBody:(NSData *)requestBody
                          completion:(void (^)(id, NSError *, NSInteger))completion {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [self url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", baseURLString, endpoint]] byAppendingParameters:params];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *requestMethod = @"GET";
    switch (method) {
        case PUT:
            requestMethod = @"PUT";
            break;
        case POST:
            requestMethod = @"POST";
            break;
        case DELETE:
            requestMethod = @"DELETE";
            break;
        default:
            break;
    }
    
    request.HTTPMethod = requestMethod;
    request.HTTPBody = requestBody;
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            
                                                            if (error) {
                                                                completion(nil, error, httpResponse.statusCode);
                                                                return;
                                                            }
                                                            
                                                            NSError *err = nil;
                                                            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:NSJSONReadingMutableContainers
                                                                                                                   error:&err];
                                                            
                                                            if (err == nil) {
                                                                completion(resp, nil, httpResponse.statusCode);
                                                            } else {
                                                                completion(nil, err, httpResponse.statusCode);
                                                            }
                                                        }];
    
    [dataTask resume];
}

@end
