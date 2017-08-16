//
//  VMKTableViewRowActionViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 22/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKAlertViewModelType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VMKTableViewRowActionViewModelStyle) {
    VMKTableViewRowActionViewModelStyleDestructive,
    VMKTableViewRowActionViewModelStyleNormal
};

@class VMKTableViewRowActionViewModel;

@protocol VMKTableViewRowActionViewModelDelegate <NSObject>
- (nullable VMKViewModel *)tableViewRowActionViewModel:(VMKTableViewRowActionViewModel *)tableViewRowActionViewModel rowActionIndexPath:(NSIndexPath *)indexPath;
@end

@interface VMKTableViewRowActionViewModel : VMKViewModel
@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, assign, readonly) VMKTableViewRowActionViewModelStyle style;
@property (nonatomic, strong, readonly, nullable) UIColor *backgroundColor;
@property (nonatomic, weak) id<VMKTableViewRowActionViewModelDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(nullable id)model NS_UNAVAILABLE;
- (instancetype)initWithTitle:(nullable NSString *)title style:(VMKTableViewRowActionViewModelStyle)style backgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<VMKTableViewRowActionViewModelDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (nullable VMKViewModel *)swipedRowActionAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
