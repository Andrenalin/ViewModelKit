//
//  VMKAlertController.h
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKAlertViewModelType.h"

NS_ASSUME_NONNULL_BEGIN

@class VMKAlertController;

@protocol VMKAlertControllerDelegate <NSObject>
- (void)alertController:(VMKAlertController *)alertController dismissedWithViewModel:(nullable VMKViewModel *)viewModel;
@end

@interface VMKAlertController : NSObject
@property (nonatomic, weak) id<VMKAlertControllerDelegate> delegate;
@property (nonatomic, weak, readonly) UIViewController *viewController;
@property (nonatomic, weak, readonly) UIView *popoverView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithViewController:(UIViewController *)viewController inPopoverView:(nullable UIView *)popoverView inSourceRect:(CGRect)location withViewModel:(VMKViewModel<VMKAlertViewModelType> *)viewModel delegate:(nullable id<VMKAlertControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
