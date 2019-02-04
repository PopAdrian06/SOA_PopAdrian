//
//  UIViewController+ErrorHandling.m
//

#import "UIViewController+ErrorHandling.h"

@implementation UIViewController (ErrorHandling)

- (void)showError:(NSError *)error message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[NSString stringWithFormat:@"%@: %@", message, error]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
