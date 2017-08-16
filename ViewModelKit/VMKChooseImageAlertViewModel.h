//
//  VMKChooseImageAlertViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKAlertViewModel.h"
#import "VMKImageEditingType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKChooseImageAlertViewModel : VMKAlertViewModel
@property (nonatomic, strong, readonly) VMKViewModel<VMKImageEditingType> *imageViewModel;
@property (nonatomic, assign, readonly) BOOL showCamera;
@property (nonatomic, assign, readonly) BOOL showPhotoLibrary;
@property (nonatomic, assign, readonly) BOOL showPasteboard;
@property (nonatomic, strong, nullable, readonly) UIPasteboard *pasteBoard;

- (instancetype)initWithViewModel:(VMKViewModel<VMKImageEditingType> *)imageViewModel showCamera:(BOOL)showCamera showPhotoLibrary:(BOOL)showPhotoLibrary showPasteboard:(BOOL)showPasteboard pasteboard:(nullable UIPasteboard *)pasteBoard NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message defaultActionTitles:(nullable NSArray *)defaultActionTitles destrcutiveActionTitles:(nullable NSArray *)destructiveActionTitles cancelActionTitle:(nullable NSString *)cancleActionTitle style:(VMKAlertViewModelStyle)style NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
