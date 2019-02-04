//
//  ShoppingistViewController.m
//

#import "ShoppingItem.h"
#import "ShoppingListViewController.h"
#import "RemoteService.h"
#import "TableViewCell.h"
#import "ItemDetailsViewController.h"

@interface ShoppingListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<ShoppingItem *> *items;
@end

@implementation ShoppingListViewController


#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getShoppingItems];
}

#pragma mark - UITableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TableViewCell reuseIdentifier]];
    
    [cell populateWithShoppingItem:self.items[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

#pragma mark - Items

- (void)getShoppingItems {
    self.items = [NSMutableArray array];
    
    [[RemoteService sharedService] getAllShoppingItemsWithCompletion:^(NSArray<ShoppingItem *> *items, NSError *error) {
        [self.items addObjectsFromArray:items];
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    ShoppingItem *item = self.items[indexPath.row];
    
    [(ItemDetailsViewController *)segue.destinationViewController setShoppingItem:item];
}

@end
