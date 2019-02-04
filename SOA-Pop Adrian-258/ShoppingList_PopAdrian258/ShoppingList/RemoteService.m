//
//  RemoteService.m
//

#import "ShoppingItem.h"
#import "RemoteService.h"

static NSString * const kConnectionString = @"http://localhost:3000";

@implementation RemoteService

#pragma mark - Setup

+ (instancetype)sharedService {
    static RemoteService *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    
    return manager;
}

#pragma mark - REST API

- (void)getAllShoppingItemsWithCompletion:(void (^)(NSArray<ShoppingItem *> *, NSError *))completion {
    [self sendRequestWithBaseURLString:kConnectionString
                              endpoint:@"items"
                         requestMethod:GET
                                params:nil
                           requestBody:nil
                            completion:^(id result, NSError *error, NSInteger statusCode) {
                                if (error != nil) {
                                    completion(nil, error);
                                    return;
                                }
                                NSArray *items = [ShoppingItem shoppingItemsArrayFromDictionaryArray:result];
                                completion(items, nil);
                            }];
}

- (void)updateShoppingItem:(ShoppingItem *)item completion:(void (^)(ShoppingItem *, NSError *, NSInteger))completion {
    [self sendRequestWithBaseURLString:kConnectionString
                              endpoint:[NSString stringWithFormat:@"item/%@", item.shoppingItemId]
                         requestMethod:PUT
                                params:nil
                           requestBody:[item toData]
                            completion:^(id result, NSError *error, NSInteger statusCode) {
                                if (error != nil) {
                                    completion(nil, error, statusCode);
                                    return;
                                }
                                
                                if (statusCode == 200 || statusCode == 409) {
                                    completion([ShoppingItem instantiateWithDictionary:result], nil, statusCode);
                                } else {
                                    completion(nil, nil, statusCode);
                                }
                            }];
}

@end
