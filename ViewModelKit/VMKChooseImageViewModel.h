//
//  VMKChooseImageViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 07/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKViewModel.h"
#import "VMKChooseImageViewModelType.h"
#import "VMKImageEditingType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKChooseImageViewModel : VMKViewModel<__kindof VMKViewModel<VMKImageEditingType> *> <VMKChooseImageViewModelType>
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(nullable id)model NS_UNAVAILABLE;
- (instancetype)initWithViewModel:(VMKViewModel<VMKImageEditingType> *)imageViewModel source:(UIImagePickerControllerSourceType)source NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
