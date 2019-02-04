//
//  EditNoteViewController.m
//  Exam
//
//  Created by Catalin Haidau on 10/06/2018.
//  Copyright © 2018 Alexandru Motoc. All rights reserved.
//

#import "ItemDetailsViewController.h"
#import "UIViewController+ErrorHandling.h"
#import "RemoteService.h"

@interface ItemDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView.text = self.note.text;
}

- (IBAction)didTapUpdate:(id)sender {
    self.note.text = self.textView.text;
    
    RemoteService *remoteService = [RemoteService sharedService];
    [remoteService updateNote:self.note completion:^(ShoppingItem *note, NSError *error, NSInteger statusCode) {
        if (error) {
            [self showError:error message:@"Uploading failed"];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)didTapDelete:(id)sender {
    RemoteService *remoteService = [RemoteService sharedService];
    [remoteService deleteNote:self.note completion:^(NSError *error, NSInteger statusCode) {
        if (error) {
            [self showError:error message:@"Deleteing failed"];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
