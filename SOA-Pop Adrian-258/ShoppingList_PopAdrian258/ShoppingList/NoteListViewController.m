//
//  NoteListViewController.m
//  Exam
//
//  Created by Alex Motoc on 01/02/2017.
//  Copyright © 2017 Alexandru Motoc. All rights reserved.
//

#import "ShoppingItem.h"
#import "ShoppingListViewController.h"
#import "RemoteService.h"
#import "TableViewCell.h"
#import "ItemDetailsViewController.h"

@interface ShoppingListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Note *> *notes;
@end

@implementation ShoppingListViewController


#pragma mark - ViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchNotesList];
}

#pragma mark - UITableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TableViewCell reuseIdentifier]];
    
    [cell populateWithNote:self.notes[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notes count];
}

#pragma mark - Notes

- (void)fetchNotesList {
    self.notes = [NSMutableArray array];
    
    [[RemoteService sharedService] fetchAllNotesWithCompletion:^(NSArray<Note *> *notes, NSError *error) {
        [self.notes addObjectsFromArray:notes];
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Note *note = self.notes[indexPath.row];
    
    [(EditNoteViewController *)segue.destinationViewController setNote:note];
}

@end
