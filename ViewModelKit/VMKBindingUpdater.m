//
//  VMKBindingUpdater.m
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKBindingUpdater+Private.h"

@implementation VMKBindingUpdater

#pragma mark - init

+ (instancetype)bindingUpdaterWithObserver:(id)observer updateAction:(SEL)updateAction {
    return [[self alloc] initWithObserver:observer updateAction:updateAction];
}

- (instancetype)initWithObserver:(id)observer updateAction:(SEL)updateAction {
    
    NSAssert([observer respondsToSelector:updateAction],
             @"observer:%@ does not respond to updateAction:%@", observer, NSStringFromSelector(updateAction));
    
    self = [super init];
    if (self) {
        _observer = observer;
        _updateAction = updateAction;
        
        // determine if the update action takes a parameter
        NSMethodSignature *updateMethodSignature = [observer  methodSignatureForSelector:updateAction];
        _updateActionsTakesBindingUpdaterParam = (updateMethodSignature && updateMethodSignature.numberOfArguments == 3);   // self, _cmd, bindingUpdater
    }
    return self;
}

#pragma mark - public interface

- (void)update {
    id strongObserver = self.observer;
    if (!strongObserver) {
        return;
    }
    
    // there is not really a good alternative to solve this without any warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (self.updateActionsTakesBindingUpdaterParam) {
        [strongObserver performSelector:self.updateAction withObject:self];
    } else {
        [strongObserver performSelector:self.updateAction];
    }
#pragma clang diagnostic pop
}

- (BOOL)isObserver:(id)observer {
    return self.observer == observer;
}

#pragma mark - NSObject

- (NSString *)description {
    NSString *superDescription = [super description];
    return [NSString stringWithFormat:@"%@ with observer:%@ updateAction:%@",
            superDescription, self.observer, NSStringFromSelector(self.updateAction)];
}

@end
