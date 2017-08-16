//
//  VMKAlertViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKAlertViewModelType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKAlertViewModel : VMKViewModel <VMKAlertViewModelType>
@property (nonatomic, assign, readonly) VMKAlertViewModelStyle style;

@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, copy, readonly, nullable) NSString *message;

@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *defaultActionTitles;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *destructiveActionTitles;
@property (nonatomic, copy, readonly, nullable) NSString *cancelActionTitle;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(nullable id)model NS_UNAVAILABLE;
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message defaultActionTitles:(nullable NSArray *)defaultActionTitles destrcutiveActionTitles:(nullable NSArray *)destructiveActionTitles cancelActionTitle:(nullable NSString *)cancleActionTitle style:(VMKAlertViewModelStyle)style NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
