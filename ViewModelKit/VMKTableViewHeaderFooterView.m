//
//  VMKTableViewHeaderFooterView.m
//  ViewModelKit
//
//  Created by daniel on 10.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKTableViewHeaderFooterView.h"
#import "VMKBindingUpdater.h"

@interface VMKTableViewHeaderFooterView ()
@property (nonatomic, assign) BOOL observingViewModel;
@property (nonatomic, assign) BOOL observingAllowed;
@end

@implementation VMKTableViewHeaderFooterView

#pragma mark - class methods

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (BOOL)automaticallyNotifiesObserversOfViewModel {
    return NO;
}

#pragma mark - init

- (void)dealloc {
    [self unbindViewModel];
}

#pragma mark - accessors

- (void)setViewModel:(VMKViewModel<VMKHeaderFooterType> *)viewModel {
    
    if (_viewModel != viewModel) {
        [self unbindViewModel];
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(viewModel))];
        _viewModel = viewModel;
        [self didChangeValueForKey:NSStringFromSelector(@selector(viewModel))];
        
        [self bindViewModel];
    }
}

#pragma mark - bindings

- (void)unbindViewModel {
    
    if (self.viewModel) {
        [self.viewModel unbindObserver:self];
        self.observingViewModel = NO;
    }
}

- (void)bindViewModel {
    
    if (self.viewModel && !self.observingViewModel && self.observingAllowed) {
        self.observingViewModel = YES;
        [self.viewModel startModelObservation];
        [self.viewModel bindBindingDictionary:[self viewModelBindings]];
    }
}

- (VMKBindingDictionary *)viewModelBindings {
    
    NSMutableDictionary<NSString *, VMKBindingUpdater *> *bindings = [[NSMutableDictionary alloc] init];
    
    if ([self.viewModel respondsToSelector:@selector(title)]) {
        [bindings addEntriesFromDictionary:@{ VMK_BINDING_PROPERTY(title) }];
    }
    
    if ([self.viewModel respondsToSelector:@selector(subtitle)]) {
        [bindings addEntriesFromDictionary:@{ VMK_BINDING_PROPERTY(subtitle) }];
    }
    
    return [bindings copy];
}

- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction {
    return [VMKBindingUpdater bindingUpdaterWithObserver:self updateAction:updateAction];
}

- (void)titleDidChange {
    if ([self.viewModel respondsToSelector:@selector(title)]) {
        self.textLabel.text = self.viewModel.title;
    }
}

- (void)subtitleDidChange {
    if ([self.viewModel respondsToSelector:@selector(subtitle)]) {
        self.detailTextLabel.text = self.viewModel.subtitle;
    }
}

#pragma mark - UITableViewHeaderFooterView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        self.observingAllowed = YES;
        [self bindViewModel];
    } else {
        [self unbindViewModel];
        self.observingAllowed = NO;
    }
}

@end
