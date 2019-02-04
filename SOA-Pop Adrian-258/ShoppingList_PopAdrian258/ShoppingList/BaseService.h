//
//  BaseService.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    GET, POST, PUT, DELETE
};

@interface BaseService : NSObject

- (void)sendRequestWithBaseURLString:(NSString *)baseURLString
                            endpoint:(NSString *)endpoint
                       requestMethod:(RequestMethod)method
                              params:(NSDictionary *)params
                         requestBody:(NSData *)requestBody
                          completion:(void (^)(id result, NSError *error, NSInteger statusCode))completion;

@end
