//
//  FakePasteBoardWithoutHasImage.h
//  ViewModelKit
//
//  Created by Andre Trettin on 13/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface FakePasteBoardWithoutHasImage : NSObject
@property (nonatomic, strong, nullable) UIImage *returnImage;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImage:(nullable UIImage *)image NS_DESIGNATED_INITIALIZER;

- (nullable UIImage *)image;
@end

NS_ASSUME_NONNULL_END
