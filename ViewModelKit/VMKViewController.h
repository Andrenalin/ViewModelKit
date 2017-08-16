//
//  VMKViewController.h
//  ViewModelKit
//
//  Created by Andre Trettin on 12.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewModel.h"
#import "VMKViewModelControllerType.h"
#import "VMKAlertController.h"
#import "VMKChooseImageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKViewController<__covariant ObjectType:__kindof VMKViewModel *> : UIViewController <VMKViewModelControllerType, VMKAlertControllerDelegate, VMKChooseImageControllerDelegate>

@property (nonatomic, strong, nullable) __kindof VMKControllerModel *controllerModel;
@property (nonatomic, strong, nullable) ObjectType viewModel;
@property (nonatomic, strong, nullable) VMKAlertController *alertController;
@property (nonatomic, strong, nullable) VMKChooseImageController *chooseImageController;

@property (nonatomic, assign, readonly) BOOL observingViewModel;
@property (nonatomic, assign, readonly) BOOL observingAllowed;

- (void)unbindViewModel;
- (void)bindViewModel;
- (VMKBindingDictionary *)viewModelBindings;
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;

- (void)presentControllerWithViewModel:(nullable VMKViewModel *)viewModel inView:(nullable UIView *)view;
@end

NS_ASSUME_NONNULL_END
