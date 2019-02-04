//
//  TableViewCell.h
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

@interface TableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;
- (void)populateWithShoppingItem:(ShoppingItem *)shoppingItem;

@end
