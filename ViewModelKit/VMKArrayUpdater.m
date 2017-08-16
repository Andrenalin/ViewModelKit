//
//  VMKArrayUpdater.m
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;  // needed for [NSIndexPath indexPathForRow:inSection:]

#import "VMKArrayUpdater.h"

#import "VMKObservableManager.h"
#import "VMKChangeSet.h"

@interface VMKArrayUpdater ()
@property (nonatomic, strong, readwrite) VMKArrayModel *arrayModel;
@property (nonatomic, strong) VMKObservableManager *observableManager;
@end

@implementation VMKArrayUpdater

- (instancetype)initWithArrayModel:(VMKArrayModel *)arrayModel delegate:(nullable id<VMKArrayUpdaterDelegate>)delegate {
    self = [super init];
    if (self) {
        _arrayModel = arrayModel;
        _delegate = delegate;
    }
    return self;
}

- (void)bindArray {
    self.observableManager = [[VMKObservableManager alloc] init];
    VMKBindingUpdater *bindingUpdater = [[VMKBindingUpdater alloc] initWithObserver:self updateAction:@selector(arrayDidChange:)];
    [self.observableManager addObject:self.arrayModel forKeyPath:@"array" bindingUpdater:bindingUpdater];
}

- (void)arrayDidChange:(VMKBindingUpdater *)bindingUpdater {
    
    NSDictionary<NSKeyValueChangeKey, id> *change = bindingUpdater.change;
    NSIndexSet *indexSet = change[NSKeyValueChangeIndexesKey];
    if (!indexSet) {
        return;
    }
    
    VMKChangeSet *changeSet = [[VMKChangeSet alloc] init];
    NSKeyValueChange kind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * _Nonnull stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
        switch (kind) {
            case NSKeyValueChangeInsertion:
                [changeSet insertedRowAtIndexPath:indexPath];
                break;
            case NSKeyValueChangeRemoval:
                [changeSet deletedRowAtIndexPath:indexPath];
                break;
            case NSKeyValueChangeSetting:
            case NSKeyValueChangeReplacement:
                [changeSet changedRowAtIndexPath:indexPath];
                break;
        }
    }];
    
    [self.delegate arrayUpdater:self didChangeWithChangeSet:changeSet];
}

@end
