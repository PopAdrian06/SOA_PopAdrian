

#import "ShoppingItem.h"

@implementation ShoppingItem

+ (instancetype)instantiateWithDictionary:(NSDictionary *)dict {
    ShoppingItem *item = [self new];
    
    item.shoppingItemId = dict[@"id"];
    item.text = dict[@"text"];
    item.updated = dict[@"updated"];
    item.completed = [dict[@"completed"] boolValue];
    
    return item;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.shoppingItemId = [coder decodeObjectForKey:@"id"];
        self.text = [coder decodeObjectForKey:@"text"];
        self.updated = [coder decodeObjectForKey:@"updated"];
        self.completed = [coder decodeBoolForKey:@"completed"];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary *dictionary = @{
                                 @"id":self.shoppingItemId,
                                 @"text":self.text,
                                 @"updated":self.updated,
                                 @"completed":@(self.isCompleted)
                                 };
    
    return dictionary;
}

+ (NSArray *)shoppingItemsArrayFromDictionaryArray:(NSArray *)dictionaryArray {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaryArray) {
        [array addObject:[ShoppingItem instantiateWithDictionary:dictionary]];
    }
    
    return array;
}

+ (NSArray *)dictionaryArrayFromShoppingItemsArray:(NSArray *)shoppingItemsArray {
    NSMutableArray *array = [NSMutableArray array];
    
    for (ShoppingItem *item in shoppingItemsArray) {
        [array addObject:[item toDictionary]];
    }
    
    return array;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.shoppingItemId forKey:@"id"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeBool:self.isCompleted forKey:@"completed"];
}

- (NSData *)toData {
    return [NSJSONSerialization dataWithJSONObject:[self toDictionary]
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

@end
