//
//  VMKViewController.m
//  ViewModelKit
//
//  Created by Andre Trettin on 12.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKViewController.h"
#import "VMKControllerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKViewController ()
@property (nonatomic, assign, readwrite) BOOL observingViewModel;
@property (nonatomic, assign, readwrite) BOOL observingAllowed;
@end

NS_ASSUME_NONNULL_END


@implementation VMKViewController

#pragma mark - class methods

+ (BOOL)automaticallyNotifiesObserversOfViewModel {
    return NO;
}

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.observingAllowed = YES;
    [self bindViewModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.observingAllowed = NO;
    [self unbindViewModel];
}

#pragma mark - properties

- (void)setViewModel:(__kindof VMKViewModel *)viewModel {
    
    if (_viewModel != viewModel) {
        [self unbindViewModel];
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(viewModel))];
        _viewModel = viewModel;
        [self didChangeValueForKey:NSStringFromSelector(@selector(viewModel))];
        
        [self bindViewModel];
    }
}

#pragma mark - bindings

- (void)unbindViewModel {
    
    if (self.viewModel) {
        [self.viewModel unbindObserver:self];
        self.observingViewModel = NO;
    }
}

- (void)bindViewModel {
    
    if (self.viewModel && !self.observingViewModel && self.observingAllowed) {
        self.observingViewModel = YES;
        [self.viewModel startModelObservation];
        [self.viewModel bindBindingDictionary:[self viewModelBindings]];
    }
}

- (VMKBindingDictionary *)viewModelBindings {
    return @{};
}

- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction {
    
    return [VMKBindingUpdater bindingUpdaterWithObserver:self updateAction:updateAction];
}

#pragma mark - editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.controllerModel.editing = editing;
}

#pragma mark - presentController

- (void)presentControllerWithViewModel:(VMKViewModel *)viewModel inView:(UIView *)view {
    
    if (!viewModel) {
        return;
    }
    
    if (!view) {
        view = self.view;
    }
    
    if ([viewModel conformsToProtocol:@protocol(VMKAlertViewModelType)]) {
        [self presentAlertControllerWithViewModel:(VMKViewModel<VMKAlertViewModelType> *)viewModel inView:view];
    }
    if ([viewModel conformsToProtocol:@protocol(VMKChooseImageViewModelType)]) {
        [self presentChooseImageControllerWithViewModel:(VMKViewModel<VMKChooseImageViewModelType> *)viewModel inView:view];
    }
}

- (void)presentAlertControllerWithViewModel:(VMKViewModel<VMKAlertViewModelType> *)viewModel inView:(UIView *)view {
    
    self.alertController = [[VMKAlertController alloc] initWithViewController:self inPopoverView:view inSourceRect:view.bounds withViewModel:viewModel delegate:self];
    [self.alertController show];
}

- (void)presentChooseImageControllerWithViewModel:(VMKViewModel<VMKChooseImageViewModelType> *)viewModel inView:(UIView *)view {
    
    self.chooseImageController = [[VMKChooseImageController alloc] initWithViewController:self inPopoverView:view inSourceRect:view.bounds withViewModel:viewModel delegate:self];
    [self.chooseImageController show];
}

#pragma mark - VMKAlertControllerDelegate

- (void)alertController:(VMKAlertController *)alertController dismissedWithViewModel:(VMKViewModel *)viewModel {
    
    self.alertController = nil;
    [self presentControllerWithViewModel:viewModel inView:alertController.popoverView];
}

#pragma mark - VMKChooseImageControllerDelegate

- (void)chooseImageController:(VMKChooseImageController *)chooseImageController dismissedWithViewModel:(VMKViewModel *)viewModel {
    
    self.chooseImageController = nil;
    [self presentControllerWithViewModel:viewModel inView:chooseImageController.popoverView];
}

@end
