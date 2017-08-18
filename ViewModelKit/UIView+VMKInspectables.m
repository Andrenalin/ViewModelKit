//
//  UIView+VMKInspectables.m
//  ViewModelKit
//
//  Created by Andre Trettin on 31.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "UIView+VMKInspectables.h"

@implementation UIView (VMKInspectables)

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    CGColorRef color = self.layer.borderColor;
    if (color) {
        return [UIColor colorWithCGColor:color];
    }
    return [UIColor clearColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

@end
