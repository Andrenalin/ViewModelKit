//
//  VMKChooseImageViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 07/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKChooseImageViewModel+Private.h"

@implementation VMKChooseImageViewModel

- (instancetype)initWithViewModel:(VMKViewModel<VMKImageEditingType> *)imageViewModel source:(UIImagePickerControllerSourceType)source {
    
    self = [super initWithModel:imageViewModel];
    if (self) {
        _source = source;
    }
    return self;
}

- (void)setImageEdit:(UIImage *)image {
    self.model.imageEdit = image;
}

@end
