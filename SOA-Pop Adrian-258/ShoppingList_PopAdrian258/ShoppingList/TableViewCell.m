//
//  TableViewCell.m
//

#import "TableViewCell.h"

@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@end

@implementation TableViewCell

+ (NSString *)reuseIdentifier {
    return @"tableViewCell";
}

- (void)populateWithShoppingItem:(ShoppingItem *)shoppingItem {
    self.contentLabel.text = shoppingItem.text;
    self.completedLabel.text = shoppingItem.completed ? @"1" : @"0";
}

@end
