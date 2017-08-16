//
//  VMKImageEditingType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 08/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKImageEditingType <NSObject>
@property (nonatomic, strong, readonly, nullable) UIImage *image;

- (void)setImageEdit:(nullable UIImage *)image;
@end

NS_ASSUME_NONNULL_END
