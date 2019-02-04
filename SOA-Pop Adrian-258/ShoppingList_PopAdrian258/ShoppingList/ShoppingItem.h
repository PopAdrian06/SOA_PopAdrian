
#import <Foundation/Foundation.h>

@interface ShoppingItem : NSObject <NSCoding>

@property (strong, nonatomic) NSString *shoppingItemId;
@property (strong, nonatomic) NSString *text;
@property (nonatomic, getter=isCompleted) BOOL completed;
@property (nonatomic) NSNumber *updated;

+ (instancetype)instantiateWithDictionary:(NSDictionary *)dict;
+ (NSArray *)shoppingItemsArrayFromDictionaryArray:(NSArray *)dictionaryArray;
+ (NSArray *)dictionaryArrayFromShoppingItemsArray:(NSArray *)shoppingItemsArray;

- (NSDictionary *)toDictionary;
- (NSData *)toData;

@end
