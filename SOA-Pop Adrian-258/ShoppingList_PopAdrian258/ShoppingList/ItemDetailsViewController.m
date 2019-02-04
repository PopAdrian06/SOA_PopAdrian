//
//  ItemDetailsViewController.m
//

#import "ItemDetailsViewController.h"
#import "UIViewController+ErrorHandling.h"
#import "RemoteService.h"

@interface ItemDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *completedSwitch;
@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView.text = self.shoppingItem.text;
    self.completedSwitch.on = self.shoppingItem.isCompleted;
}

- (IBAction)didTapUpdate:(id)sender {
    self.shoppingItem.text = self.textView.text;
    
    RemoteService *remoteService = [RemoteService sharedService];
    [remoteService updateShoppingItem:self.shoppingItem completion:^(ShoppingItem *item, NSError *error, NSInteger statusCode) {
        if (error) {
            [self showError:error message:@"Uploading failed"];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)didChangeValue:(UISwitch *)sender {
    self.shoppingItem.completed = sender.isOn;
}

@end
