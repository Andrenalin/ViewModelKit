//
//  VMKCollectionViewCell.m
//  ViewModelKit
//
//  Created by Daniel Rinser on 04.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKCollectionViewCell.h"
#import "VMKBindingUpdater.h"

@interface VMKCollectionViewCell ()
@property (nonatomic, assign) BOOL observingViewModel;
@property (nonatomic, assign) BOOL observingAllowed;
@end

@implementation VMKCollectionViewCell

#pragma mark - class methods

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (BOOL)automaticallyNotifiesObserversOfViewModel {
    return NO;
}

#pragma mark - Init

- (void)dealloc {
    [self unbindViewModel];
}

#pragma mark - accessors

- (void)setViewModel:(__kindof VMKViewModel<VMKCellType> *)viewModel {
    
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

- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction {
    return [VMKBindingUpdater bindingUpdaterWithObserver:self updateAction:updateAction];
}

// to be overridden in subclasses
- (VMKBindingDictionary *)viewModelBindings {
    return @{};
}

#pragma mark - UICollectionViewCell

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
