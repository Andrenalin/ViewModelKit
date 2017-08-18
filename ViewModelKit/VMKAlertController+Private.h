//
//  VMKAlertController+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKAlertController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKAlertController ()
@property (nonatomic, weak, readwrite) UIViewController *viewController;
@property (nonatomic, weak, readwrite) UIView *popoverView;
@property (nonatomic, assign) CGRect location;
@property (nonatomic, strong) VMKViewModel<VMKAlertViewModelType> *viewModel;

@property (nonatomic, strong, nullable) UIAlertController *alertController;

- (void)handleActionWithTitle:(nullable NSString *)title;
@end

NS_ASSUME_NONNULL_END
