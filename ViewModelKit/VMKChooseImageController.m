//
//  VMKChooseImageController.m
//  ViewModelKit
//
//  Created by Andre Trettin on 29/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKChooseImageController+Private.h"

@implementation VMKChooseImageController

- (instancetype)initWithViewController:(UIViewController *)viewController inPopoverView:(UIView *)popoverView inSourceRect:(CGRect)location withViewModel:(VMKViewModel<VMKChooseImageViewModelType> *)viewModel delegate:(id<VMKChooseImageControllerDelegate>)delegate {
    
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

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController) {
        return _imagePickerController;
    }

    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    
    return _imagePickerController;
}

#pragma mark - public interface

- (void)show {
    self.imagePickerController.sourceType = self.viewModel.source;
    [self.viewController presentViewController:(UIImagePickerController *)self.imagePickerController animated:YES completion:nil];
}

- (void)dismiss {
    if (_imagePickerController) { // prevent to create a new image picker
        [self dismissImagePickerController];
    }
}

#pragma mark - edit view model

- (void)setImage:(UIImage *)image {
    [self.viewModel setImageEdit:image];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissImagePickerController];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    if (!newImage) {
        newImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (newImage) {
        [self setImage:newImage];
    }

    [self dismissImagePickerController];
}

- (void)dismissImagePickerController {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    _imagePickerController = nil;
    [self.delegate chooseImageController:self dismissedWithViewModel:nil];
}

@end
