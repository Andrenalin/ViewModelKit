//
//  VMKBindingUpdater.h
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN


/**
 @brief The BindingUpdater calls the updateAction method from the observer on update.
 */
@interface VMKBindingUpdater : NSObject
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSKeyValueChangeKey, id> *change;
@property (weak, nonatomic, readonly) id observer;

+ (instancetype)bindingUpdaterWithObserver:(id)observer updateAction:(SEL)updateAction;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithObserver:(id)observer updateAction:(SEL)updateAction NS_DESIGNATED_INITIALIZER;

- (void)update;
- (BOOL)isObserver:(id)observer;
@end

NS_ASSUME_NONNULL_END
