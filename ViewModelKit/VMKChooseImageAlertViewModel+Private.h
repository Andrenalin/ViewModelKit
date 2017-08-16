//
//  VMKChooseImageAlertViewModel+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKChooseImageAlertViewModel.h"
#import "VMKAlertViewModel+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKChooseImageAlertViewModel ()
@property (nonatomic, strong, readwrite) VMKViewModel<VMKImageEditingType> *imageViewModel;
@property (nonatomic, assign, readwrite) BOOL showCamera;
@property (nonatomic, assign, readwrite) BOOL showPhotoLibrary;
@property (nonatomic, assign, readwrite) BOOL showPasteboard;
@property (nonatomic, strong, nullable, readwrite) UIPasteboard *pasteBoard;

+ (NSString *)defaultTakePhotoTitle;
@end

NS_ASSUME_NONNULL_END
