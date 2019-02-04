//
//  RemoteService.h
//

#import "BaseService.h"
#import <Foundation/Foundation.h>

@interface RemoteService : BaseService

+ (instancetype)sharedService;

- (void)getAllShoppingItemsWithCompletion:(void (^)(NSArray <ShoppingItem *> *items, NSError *error))completion;
- (void)updateShoppingItem:(ShoppingItem *)item completion:(void (^)(ShoppingItem *item, NSError *error, NSInteger statusCode))completion;

@end
