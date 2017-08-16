//
//  VMKObservableManager.m
//  ViewModelKit
//
//  Created by Andre Trettin on 24.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKObservableManager+Private.h"

@implementation VMKObservableManager

#pragma mark - accessors

- (NSMutableArray *)observables {
    if (!_observables) {
        _observables = [NSMutableArray new];
    }
    return _observables;
}

#pragma mark - add bindings

- (void)addObject:(id)object forKeyPath:(NSString *)keyPath bindingUpdater:(VMKBindingUpdater *)bindingUpdater {
    [self addObject:object forKeyPath:keyPath bindingUpdater:bindingUpdater options:VMKObservableDefaultKVOOptions];
}

- (void)addObject:(id)object forKeyPath:(NSString *)keyPath bindingUpdater:(VMKBindingUpdater *)bindingUpdater options:(NSKeyValueObservingOptions)options {
    
#ifdef DEBUG
    // check if the same observer is already registered for the same keypath on the same object
    for (VMKObservable *observable in self.observables) {
        if ([observable isKeyPath:keyPath] && [observable isObject:object] && [observable isObserver:(_Nonnull id)bindingUpdater.observer]) {
            NSAssert(NO, @"<%@: %p> is already registered as an observer for key path \"%@\" on <%@: %p>",
                     [bindingUpdater.observer class], (void *)bindingUpdater.observer, keyPath, [object class], (void *)object);
        }
    }
#endif
    
    VMKObservable *observer = [[VMKObservable alloc] initWithObject:object forKeyPath:keyPath bindingUpdater:bindingUpdater options:options];
    [observer startObservation];
    
    [self.observables addObject:observer];
}

- (void)addObject:(id)object withBindings:(VMKBindingDictionary *)bindings {
    [self addObject:object withBindings:bindings options:VMKObservableDefaultKVOOptions];
}

- (void)addObject:(id)object withBindings:(VMKBindingDictionary *)bindings options:(NSKeyValueObservingOptions)options {
    
    [bindings enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull keyPath, VMKBindingUpdater * _Nonnull updater, BOOL * _Nonnull stop) {
        [self addObject:object forKeyPath:keyPath bindingUpdater:updater options:options];
    }];
}

#pragma mark - remove bindings

typedef void (^VMKObservableBlock)(VMKObservable *observable, NSMutableArray *removable);

- (void)removeAllObserverForKeyPath:(NSString *)keyPath {
    
    [self removeObserverWithBlock:^(VMKObservable *observable, NSMutableArray *removables) {
        if ([observable isKeyPath:keyPath]) {
            [removables addObject:observable];
        }
    }];
}

- (void)removeBindingObserver:(id)observer {
    
    [self removeObserverWithBlock:^(VMKObservable *observable, NSMutableArray *removables) {
        if ([observable isObserver:observer]) {
            [removables addObject:observable];
        }
    }];
}

- (void)removeBindingObserver:(id)observer forKeyPath:(NSString *)keyPath {
    
    [self removeObserverWithBlock:^(VMKObservable *observable, NSMutableArray *removables) {
        if ([observable isObserver:observer]) {
            if ([observable isKeyPath:(NSString *)keyPath]) {
                [removables addObject:observable];
            }
        }
    }];
}

- (void)removeObserverForObject:(id)object {
    
    [self removeObserverWithBlock:^(VMKObservable *observable, NSMutableArray *removables) {
        if ([observable isObject:object]) {
            [removables addObject:observable];
        }
    }];
}

- (void)removeObserverWithBlock:(VMKObservableBlock)block {
    
    NSMutableArray<VMKObservable *> *removeObservables = [NSMutableArray new];
    for (VMKObservable *observable in self.observables) {
        block(observable, removeObservables);
    }
    [self.observables removeObjectsInArray:removeObservables];
}

- (void)removeAllBindings {
    [self.observables removeAllObjects];
}

#pragma mark - NSObject

- (NSString *)description {
    NSString *superDescription = [super description];
    return [NSString stringWithFormat:@"%@ has %td observables", superDescription, self.observables.count];
}

@end
