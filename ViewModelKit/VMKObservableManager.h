//
//  VMKObservableManager.h
//  ViewModelKit
//
//  Created by Andre Trettin on 24.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKBindingUpdater.h"

typedef NSDictionary<NSString *, VMKBindingUpdater *> VMKBindingDictionary;

NS_ASSUME_NONNULL_BEGIN


/**
 @brief The observable manager manages VMKObservable objects. It keep track of all bindings for an observer.
 
 Use an instance of this class for every observer to hold a strong reference to the observables.
 After the observer is gone the manager removes the observables as well.
 */
@interface VMKObservableManager : NSObject

#pragma mark - add bindings

- (void)addObject:(id)object forKeyPath:(NSString *)keyPath bindingUpdater:(VMKBindingUpdater *)bindingUpdater; // default options = new | initial
- (void)addObject:(id)object forKeyPath:(NSString *)keyPath bindingUpdater:(VMKBindingUpdater *)bindingUpdater options:(NSKeyValueObservingOptions)options;

- (void)addObject:(id)object withBindings:(VMKBindingDictionary *)bindings; // default options = new | initial
- (void)addObject:(id)object withBindings:(VMKBindingDictionary *)bindings options:(NSKeyValueObservingOptions)options;

#pragma mark - remove bindings

- (void)removeAllObserverForKeyPath:(NSString *)keyPath;
- (void)removeBindingObserver:(id)observer;
- (void)removeBindingObserver:(id)observer forKeyPath:(NSString *)keyPath;
- (void)removeObserverForObject:(id)object;
- (void)removeAllBindings;
@end

NS_ASSUME_NONNULL_END
