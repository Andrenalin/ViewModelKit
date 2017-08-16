//
//  VMKAlertController.m
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKAlertController+Private.h"

@implementation VMKAlertController

- (instancetype)initWithViewController:(UIViewController *)viewController inPopoverView:(UIView *)popoverView inSourceRect:(CGRect)location withViewModel:(VMKViewModel<VMKAlertViewModelType> *)viewModel delegate:(nullable id<VMKAlertControllerDelegate>)delegate {
    
    self = [super init];
    if (self) {
        _viewController = viewController;
        _popoverView = popoverView;
        _location = location;
        _viewModel = viewModel;
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [self dismiss];
}

#pragma mark - accessors

- (UIAlertController *)alertController {
    if (_alertController) {
        return _alertController;
    }
    
    UIAlertControllerStyle preferredStyle = UIAlertControllerStyleActionSheet;
    if (self.viewModel.style == VMKAlertViewModelStyleAlert) {
        preferredStyle = UIAlertControllerStyleAlert;
    }
    
    _alertController = [UIAlertController alertControllerWithTitle:self.viewModel.title message:self.viewModel.message preferredStyle:preferredStyle];
    
    [self addActions];
    
    if (self.popoverView) {
        _alertController.modalPresentationStyle = UIModalPresentationPopover;
        _alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        _alertController.popoverPresentationController.sourceRect = self.location;
        _alertController.popoverPresentationController.sourceView = self.popoverView;
    }
    
    return _alertController;
}

#pragma mark - public interface

- (void)show {
    [self.viewController presentViewController:(UIAlertController *)self.alertController animated:YES completion:nil];
}

- (void)dismiss {
    if (_alertController) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
        [self.delegate alertController:self dismissedWithViewModel:nil];
        self.alertController = nil;
    }
}

#pragma mark - configure actions

- (void)addActions {
    [self addDefaultActions];
    [self addDestructiveActions];
    [self addCancelAction];
}

- (void)addDefaultActions {
    for (NSString *title in self.viewModel.defaultActionTitles) {
        [self addActionWithTitle:title style:UIAlertActionStyleDefault];
    }
}

- (void)addDestructiveActions {
    for (NSString *title in self.viewModel.destructiveActionTitles) {
        [self addActionWithTitle:title style:UIAlertActionStyleDestructive];
    }
}

- (void)addCancelAction {
    
    NSString *title = self.viewModel.cancelActionTitle;
    if (title) {
        [self addActionWithTitle:title style:UIAlertActionStyleCancel];
    }
}

- (void)addActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style {
    
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull alertAction) {
        
        __typeof(self) strongSelf = weakSelf;
        [strongSelf handleActionWithTitle:alertAction.title];
    }];
    [self.alertController addAction:action];
}

- (void)handleActionWithTitle:(NSString *)title {
    
    if ([self.viewModel respondsToSelector:@selector(tappedActionWithTitle:)]) {
        VMKViewModel *nextViewModel = [self.viewModel tappedActionWithTitle:title];
        [self.delegate alertController:self dismissedWithViewModel:nextViewModel];
    }
    self.alertController = nil;
}

@end
