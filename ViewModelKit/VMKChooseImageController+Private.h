//
//  VMKChooseImageController+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 07/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKChooseImageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKChooseImageController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak, readwrite) UIViewController *viewController;
@property (nonatomic, weak, readwrite) UIView *popoverView;
@property (nonatomic, assign) CGRect location;
@property (nonatomic, strong, readwrite) VMKViewModel<VMKChooseImageViewModelType> *viewModel;

@property (nonatomic, strong, nullable) UIImagePickerController *imagePickerController;
@end

NS_ASSUME_NONNULL_END
