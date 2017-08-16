//
//  VMKCollectionViewController.h
//  ViewModelKit
//
//  Created by Daniel Rinser on 04.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewModelControllerType.h"
#import "VMKDataSourceViewModelType.h"
#import "VMKCollectionViewDataSourceDelegate.h"

#import "VMKAlertController.h"
#import "VMKChooseImageController.h"


NS_ASSUME_NONNULL_BEGIN

@interface VMKCollectionViewController<__covariant ObjectType:__kindof VMKViewModel<VMKDataSourceViewModelType> *> : UICollectionViewController <VMKViewModelControllerType, VMKCollectionViewDataSourceDelegate, VMKAlertControllerDelegate, VMKChooseImageControllerDelegate>

@property (nonatomic, strong, nullable) __kindof VMKControllerModel *controllerModel;
@property (nonatomic, strong, nullable) ObjectType viewModel;
@property (nonatomic, strong, nullable) VMKAlertController *alertController;
@property (nonatomic, strong, nullable) VMKChooseImageController *chooseImageController;

/// Indicates whether changes from the data source should by applied animated or not; defaults to NO
@property (nonatomic, assign) BOOL disableChangeAnimations;

- (VMKBindingDictionary *)viewModelBindings;
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;

- (void)presentControllerWithViewModel:(nullable VMKViewModel *)viewModel inView:(nullable UIView *)view;

// subclassing hooks
- (void)didFinishApplyingChangeSet;

#pragma mark - bindings did change hooks

- (BOOL)dataSourceDidChange;
@end

NS_ASSUME_NONNULL_END
