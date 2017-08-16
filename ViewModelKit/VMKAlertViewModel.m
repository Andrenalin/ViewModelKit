//
//  VMKAlertViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKAlertViewModel+Private.h"

@implementation VMKAlertViewModel

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message defaultActionTitles:(NSArray *)defaultActionTitles destrcutiveActionTitles:(NSArray *)destructiveActionTitles cancelActionTitle:(NSString *)cancleActionTitle style:(VMKAlertViewModelStyle)style {
    
    self = [super initWithModel:nil];
    if (self) {
        _style = style;
        _title = title;
        _message = message;
        _defaultActionTitles = defaultActionTitles;
        _destructiveActionTitles = destructiveActionTitles;
        _cancelActionTitle = cancleActionTitle;
    }
    return self;
}

@end
