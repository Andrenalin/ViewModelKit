//
//  VMKTableViewController.h
//  ViewModelKit
//
//  Created by Andre Trettin on 27/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewModelControllerType.h"
#import "VMKDataSourceViewModelType.h"
#import "VMKTableViewDataSourceDelegate.h"

#import "VMKAlertController.h"
#import "VMKChooseImageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewController<__covariant ObjectType:__kindof VMKViewModel<VMKDataSourceViewModelType> *> : UITableViewController <VMKViewModelControllerType, VMKTableViewDataSourceDelegate, VMKAlertControllerDelegate, VMKChooseImageControllerDelegate>

@property (nonatomic, strong, nullable) __kindof VMKControllerModel *controllerModel;
@property (nonatomic, strong, nullable) ObjectType viewModel;
@property (nonatomic, strong, nullable) VMKAlertController *alertController;
@property (nonatomic, strong, nullable) VMKChooseImageController *chooseImageController;

@property (nonatomic, strong, nullable) NSIndexPath *selectedIndexPath;

- (VMKBindingDictionary *)viewModelBindings;
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;

- (void)presentControllerWithViewModel:(nullable VMKViewModel *)viewModel inView:(nullable UIView *)view;

#pragma mark - bindings did change hooks

- (BOOL)dataSourceDidChange;
@end

NS_ASSUME_NONNULL_END
