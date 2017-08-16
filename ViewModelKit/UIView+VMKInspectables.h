//
//  UIView+VMKInspectables.h
//  ViewModelKit
//
//  Created by Andre Trettin on 31.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UIView (VMKInspectables)
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@end

NS_ASSUME_NONNULL_END
