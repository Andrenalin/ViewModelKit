//
//  VMKViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 06.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKViewModel+Private.h"

#import "VMKCellType.h"
#import "VMKDataSourceViewModelType.h"

@implementation VMKViewModel

#pragma mark - class methods

+ (BOOL)automaticallyNotifiesObserversOfModel {
    return NO;
}

#pragma mark - init

- (instancetype)initWithModel:(id)model {
    self = [self init];
    if (self) {
        _model = model;
    }
    return self;
}

#pragma mark - accessors

- (VMKObservableManager *)observableManager {
    if (!_observableManager) {
        _observableManager = [[VMKObservableManager alloc] init];
    }
    return _observableManager;
}

- (VMKObservableManager *)externalBindingManager {
    if (!_externalBindingManager) {
        _externalBindingManager = [[VMKObservableManager alloc] init];
    }
    return _externalBindingManager;
}

- (void)setModel:(id)model {
    
    if (_model != model) {
        [self unbindModel];
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(model))];
        _model = model;
        [self didChangeValueForKey:NSStringFromSelector(@selector(model))];
        
        [self bindModel];
    }
}

#pragma mark - bindings

- (void)unbindModel {
    if (_model) {
        [self.observableManager removeObserverForObject:(id)_model];
        self.observingModel = NO;
    }
}

- (void)bindModel {
    if (_model && !self.observingModel) {
        self.observingModel = YES;
        [self.observableManager addObject:(id)_model withBindings:[self modelBindings]];
    }
}

- (VMKBindingDictionary *)modelBindings {
    return @{};
}

- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction {
    return [VMKBindingUpdater bindingUpdaterWithObserver:self updateAction:updateAction];
}

#pragma mark - interface for the view controllers / controllers / owner of the view model

- (void)startModelObservation {
    [self bindModel];
}

- (void)bindBindingDictionary:(VMKBindingDictionary *)bindingDictionary {
    [self.externalBindingManager addObject:self withBindings:bindingDictionary];
}

- (void)bindUpdater:(VMKBindingUpdater *)bindingUpdater toKeyPath:(NSString *)keyPath {
    [self.externalBindingManager addObject:self forKeyPath:keyPath bindingUpdater:bindingUpdater];
}

- (void)bindObject:(id)object updateAction:(SEL)updateAction toKeyPath:(NSString *)keyPath {
    VMKBindingUpdater *updater = [VMKBindingUpdater bindingUpdaterWithObserver:object updateAction:updateAction];
    [self bindUpdater:updater toKeyPath:keyPath];
}

- (void)unbindKeyPath:(NSString *)keyPath {
    [self.externalBindingManager removeAllObserverForKeyPath:keyPath];
}

- (void)unbindObserver:(id)observer {
    [self.externalBindingManager removeBindingObserver:observer];
}

- (void)unbindObserver:(id)observer fromKeyPath:(NSString *)keyPath {
    [self.externalBindingManager removeBindingObserver:observer forKeyPath:keyPath];
}

- (void)unbindAllConnections {
    if (_externalBindingManager) {
        [self.externalBindingManager removeAllBindings];;
    }
}

#pragma mark - NSObject

- (NSString *)description {
    NSString *superDescription = [super description];
    return [NSString stringWithFormat:@"%@ - is %@observing model - observes:\n%@\nbindings:\n%@", superDescription, self.observingModel ? @"" : @"not ", self.observableManager, self.externalBindingManager];
}

@end
