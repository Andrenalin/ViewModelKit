//
//  VMKAlertViewModel+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKAlertViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKAlertViewModel ()
@property (nonatomic, assign, readwrite) VMKAlertViewModelStyle style;

@property (nonatomic, copy, readwrite, nullable) NSString *title;
@property (nonatomic, copy, readwrite, nullable) NSString *message;

@property (nonatomic, copy, readwrite, nullable) NSArray<NSString *> *defaultActionTitles;
@property (nonatomic, copy, readwrite, nullable) NSArray<NSString *> *destructiveActionTitles;
@property (nonatomic, copy, readwrite, nullable) NSString *cancelActionTitle;
@end

NS_ASSUME_NONNULL_END
