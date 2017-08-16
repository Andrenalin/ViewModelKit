//
//  VMKChooseImageAlertViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKChooseImageAlertViewModel+Private.h"
#import "VMKChooseImageViewModel.h"

@implementation VMKChooseImageAlertViewModel

#pragma mark - default values

+ (NSString *)defaultTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Title", @"DefaultViewModelKit", bundle, @"Edit Image", @"The default title of choose image alert controller sheet");
}

+ (NSString *)defaultMessage {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Message", @"DefaultViewModelKit", bundle, @"Choose how you would like to edit the image.", @"The default message of choose image alert controller sheet");
}

+ (NSString *)defaultTakePhotoTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Take_Photo_Title", @"DefaultViewModelKit", bundle, @"Take Photo", @"The default title for the take photo action of choose image alert controller sheet");
}

+ (NSString *)defaultChoosePhotoTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Choose_Photo_Title", @"DefaultViewModelKit", bundle, @"Choose Photo", @"The default title for the choose photo action of choose image alert controller sheet");
}

+ (NSString *)defaultPastePhotoTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Paste_Photo_Title", @"DefaultViewModelKit", bundle, @"Paste Photo", @"The default title for the paste photo action of choose image alert controller sheet");
}

+ (NSString *)defaultDeletePhotoTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Delete_Photo_Title", @"DefaultViewModelKit", bundle, @"Delete Photo", @"The default title for the delete photo action of choose image alert controller sheet");
}

+ (NSString *)defaultCancelTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return  NSLocalizedStringWithDefaultValue(@"ChooseImageAlertViewModel_Default_Cancel_Title", @"DefaultViewModelKit", bundle, @"Cancel", @"The default title for the cancel action of choose image alert controller sheet");
}

#pragma mark - init

- (instancetype)initWithViewModel:(VMKViewModel<VMKImageEditingType> *)imageViewModel showCamera:(BOOL)showCamera showPhotoLibrary:(BOOL)showPhotoLibrary showPasteboard:(BOOL)showPasteboard pasteboard:(nullable UIPasteboard *)pasteBoard {

    self = [super initWithTitle:[VMKChooseImageAlertViewModel defaultTitle] message:[VMKChooseImageAlertViewModel defaultMessage] defaultActionTitles:nil destrcutiveActionTitles:nil cancelActionTitle:nil style:VMKAlertViewModelStyleSheet];
    if (self) {
        _imageViewModel = imageViewModel;
        _showCamera = showCamera;
        _showPhotoLibrary = showPhotoLibrary;
        _showPasteboard = showPasteboard;
        _pasteBoard = pasteBoard;
        
        [self generateActionTtiles];
    }
    return self;
}

- (void)generateActionTtiles {
    NSMutableArray<NSString *> *defaultActionTitles = [[NSMutableArray alloc] initWithCapacity:3];
    
    if ([self hasCamera]) {
        [defaultActionTitles addObject:[VMKChooseImageAlertViewModel defaultTakePhotoTitle]];
    }
    if ([self hasPhotoLibrary]) {
        [defaultActionTitles addObject:[VMKChooseImageAlertViewModel defaultChoosePhotoTitle]];
    }
    if ([self hasImageInPasteboard]) {
        [defaultActionTitles addObject:[VMKChooseImageAlertViewModel defaultPastePhotoTitle]];
    }
    self.defaultActionTitles = [defaultActionTitles copy];
    
    if ([self hasAnImage]) {
        self.destructiveActionTitles = @[ [VMKChooseImageAlertViewModel defaultDeletePhotoTitle] ];
    }
    self.cancelActionTitle = [VMKChooseImageAlertViewModel defaultCancelTitle];
}

#pragma mark - has action flags

- (BOOL)hasImageInPasteboard {
    if (!self.showPasteboard) {
        return NO;
    }
    
    if ([self.pasteBoard respondsToSelector:@selector(hasImages)]) {
        // iOS 10.0
        return self.pasteBoard.hasImages;
    }
    
    // iOS 9.x
    UIImage *image = self.pasteBoard.image;
    return image != nil;
}

- (BOOL)hasCamera {
    if (!self.showCamera) {
        return NO;
    }
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)hasPhotoLibrary {
    if (!self.showPhotoLibrary) {
        return NO;
    }
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)hasAnImage {
    return (self.imageViewModel.image != nil);
}

#pragma mark - VMKAlertViewModelType optional

- (nullable VMKViewModel *)tappedActionWithTitle:(NSString *)title {
    
    if ([title isEqualToString:[VMKChooseImageAlertViewModel defaultDeletePhotoTitle]]) {
        self.imageViewModel.imageEdit = nil;
    }
    if ([title isEqualToString:[VMKChooseImageAlertViewModel defaultPastePhotoTitle]]) {
        self.imageViewModel.imageEdit = self.pasteBoard.image;
    }
    if ([title isEqualToString:[VMKChooseImageAlertViewModel defaultChoosePhotoTitle]]) {
        VMKChooseImageViewModel *viewModel = [[VMKChooseImageViewModel alloc] initWithViewModel:self.imageViewModel source:UIImagePickerControllerSourceTypePhotoLibrary];
        return viewModel;
    }
    if ([title isEqualToString:[VMKChooseImageAlertViewModel defaultTakePhotoTitle]]) {
        VMKChooseImageViewModel *viewModel = [[VMKChooseImageViewModel alloc] initWithViewModel:self.imageViewModel source:UIImagePickerControllerSourceTypeCamera];
        return viewModel;
    }
    
    return nil;
}

@end
