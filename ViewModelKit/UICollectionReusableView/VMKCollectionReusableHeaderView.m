//
//  VMKCollectionReusableHeaderView.m
//  ViewModelKit
//
//  Created by Peter Darbey on 08/06/2020.
//  Copyright © 2020 Andre Trettin. All rights reserved.
//

#import "VMKCollectionReusableHeaderView.h"

@interface VMKCollectionReusableHeaderView ()
@property (nonatomic, assign) BOOL observingViewModel;
@property (nonatomic, assign) BOOL observingAllowed;
@end

@implementation VMKCollectionReusableHeaderView

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
        
        [self willChangeValueForKey: NSStringFromSelector(@selector(viewModel))];
        _viewModel = viewModel;
        [self didChangeValueForKey: NSStringFromSelector(@selector(viewModel))];
        
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
        
        [self.viewModel bindBindingDictionary: [self viewModelBindings]];
    }
}

// to be overridden in subclasses
- (VMKBindingDictionary *)viewModelBindings {
    return @{ };
}

#pragma mark - UICollectionReusableView

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
