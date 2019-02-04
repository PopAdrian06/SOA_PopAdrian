//
//  UIViewController+ErrorHandling.h
//

#import <UIKit/UIKit.h>

@interface UIViewController (ErrorHandling)

- (void)showError:(NSError *)error message:(NSString *)message;

@end
