//
//  VMKMutableArrayDataSource.m
//  ViewModelKit
//
//  Created by Daniel Rinser on 09.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKMutableArrayDataSource+Private.h"

@implementation VMKMutableArrayDataSource

#pragma mark - init

- (instancetype)initWithArrayModel:(VMKArrayModel *)arrayModel factory:(nullable id<VMKCellViewModelFactory>)factory {

    self = [super init];
    if (self) {
        _arrayModel = arrayModel;
        _factory = factory;
    }
    return self;
}

- (void)setUpBinding {
    [self.arrayUpdater bindArray];
}

#pragma mark - Accessors

- (VMKViewModelCache *)viewModelCache {
    if (!_viewModelCache) {
        _viewModelCache = [[VMKViewModelCache alloc] init];
    }
    return _viewModelCache;
}

- (VMKArrayUpdater *)arrayUpdater {
    if (_arrayUpdater) {
        return _arrayUpdater;
    }
    _arrayUpdater = [[VMKArrayUpdater alloc] initWithArrayModel:self.arrayModel delegate:self];
    return _arrayUpdater;
}

#pragma mark - VMKDataSourceType

- (NSInteger)sections {
    return 1;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    return (NSInteger)self.arrayModel.count;
}

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    VMKViewModel<VMKCellType> *vm = [self.viewModelCache viewModelAtIndexPath:indexPath];
    if (vm) {
        return vm;
    }
    return [self insertedViewModelInCacheAtIndexPath:indexPath];
}

#pragma mark - cache

- (nullable __kindof VMKViewModel<VMKCellType> *)insertedViewModelInCacheAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.arrayModel objectAtIndex:(NSUInteger)indexPath.row];
    
    if (!object) {
        return nil;
    }
    
    __kindof VMKViewModel<VMKCellType> *vm = [self.factory cellViewModelForDataSource:self object:object];
    if (vm) {
        [self.viewModelCache setViewModel:vm atIndexPath:indexPath];
    }
    return vm;
}

#pragma mark - VMKArrayUpdaterDelegate

- (void)arrayUpdater:(VMKArrayUpdater *)arrayUpdater didChangeWithChangeSet:(VMKChangeSet *)changeSet {
    
    if (changeSet.history.count > 0) {
        [self.viewModelCache changeCacheWithChangeSet:changeSet];
        [self.delegate dataSource:self didUpdateChangeSet:changeSet];
    }
}

@end
