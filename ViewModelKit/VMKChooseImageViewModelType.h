//
//  VMKChooseImageViewModelType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 29/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKChooseImageViewModelType <NSObject>
@property (nonatomic, assign, readonly) UIImagePickerControllerSourceType source;

- (void)setImageEdit:(nullable UIImage *)image;
@end

NS_ASSUME_NONNULL_END
