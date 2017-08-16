//
//  VMKAlertViewModelType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VMKAlertViewModelStyle) {
    VMKAlertViewModelStyleSheet,
    VMKAlertViewModelStyleAlert
};

@protocol VMKAlertViewModelType <NSObject>
@property (nonatomic, assign, readonly) VMKAlertViewModelStyle style;

@property (nonatomic, copy, readonly, nullable) NSString *title;
@property (nonatomic, copy, readonly, nullable) NSString *message;

@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *defaultActionTitles;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *destructiveActionTitles;
@property (nonatomic, copy, readonly, nullable) NSString *cancelActionTitle;

@optional
- (nullable VMKViewModel *)tappedActionWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
