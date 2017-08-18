//
//  VMKChooseImageController.h
//  ViewModelKit
//
//  Created by Andre Trettin on 29/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewModel.h"
#import "VMKChooseImageViewModelType.h"

NS_ASSUME_NONNULL_BEGIN

@class VMKChooseImageController;

@protocol VMKChooseImageControllerDelegate <NSObject>
- (void)chooseImageController:(VMKChooseImageController *)chooseImageController dismissedWithViewModel:(nullable VMKViewModel *)viewModel;
@end

@interface VMKChooseImageController : NSObject
@property (nonatomic, weak) id<VMKChooseImageControllerDelegate> delegate;
@property (nonatomic, weak, readonly) UIViewController *viewController;
@property (nonatomic, weak, readonly) UIView *popoverView;
@property (nonatomic, strong, readonly) VMKViewModel<VMKChooseImageViewModelType> *viewModel;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithViewController:(UIViewController *)viewController inPopoverView:(nullable UIView *)popoverView inSourceRect:(CGRect)location withViewModel:(VMKViewModel<VMKChooseImageViewModelType> *)viewModel delegate:(nullable id<VMKChooseImageControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
