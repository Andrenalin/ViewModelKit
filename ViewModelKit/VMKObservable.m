//
//  VMKObservable.m
//  ViewModelKit
//
//  Created by Andre Trettin on 24.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKObservable+Private.h"

@implementation VMKObservable

NSUInteger const VMKObservableDefaultKVOOptions = (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial);

#pragma mark - init

- (void)dealloc {
    [self removeObservable];
}

- (instancetype)initWithObject:(NSObject *)object forKeyPath:(NSString *)keyPath bindingUpdater:(nonnull VMKBindingUpdater *)bindingUpdater {
    
    return [self initWithObject:object forKeyPath:keyPath bindingUpdater:bindingUpdater options:VMKObservableDefaultKVOOptions];
}

- (instancetype)initWithObject:(NSObject *)object forKeyPath:(NSString *)keyPath bindingUpdater:(nonnull VMKBindingUpdater *)bindingUpdater options:(NSKeyValueObservingOptions)options {
    
    self = [super init];
    if (self) {
        _object = object;
        _keyPath = [keyPath copy];
        _kvoOptions = options;
        _bindingUpdater = bindingUpdater;
        _observing = NO;
    }
    return self;
}

#pragma mark - public interface

- (void)startObservation {
    if (!self.observing) {
        [self addObservable];
    }
}

- (BOOL)isKeyPath:(NSString *)keyPath {
    return [self.keyPath isEqualToString:keyPath];
}

- (BOOL)isObserver:(id)observer {
    return [self.bindingUpdater isObserver:observer];
}

- (BOOL)isObject:(id)object {
    return self.object == object;
}

#pragma mark - kvo setup

- (void)addObservable {

    NSAssert([self.object vmk_canSetValueForKeyPath:self.keyPath],
             @"object:%@ does not responds to keypath:%@", self.object, self.keyPath);
    
    self.observing = YES;
    [self.object addObserver:self forKeyPath:self.keyPath options:self.kvoOptions context:NULL];
}

- (void)removeObservable {
    if (self.observing) {
        [self.object removeObserver:self forKeyPath:self.keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:self.keyPath]) {
        self.bindingUpdater.change = change;
        [self.bindingUpdater update];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSObject

- (NSString *)description {
    NSString *superDescription = [super description];
    return [NSString stringWithFormat:@"%@ --> Observable for KeyPath:%@ of Object:%@ with updater: %@",
            superDescription, self.keyPath, self.object, self.bindingUpdater];
}

@end
