//
//  VMKMultipleDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKMultipleDataSource+Private.h"

#import "VMKChangeSet.h"

@implementation VMKMultipleDataSource

@synthesize dataSources = _dataSources;

#pragma mark - init

- (instancetype)initWithDataSources:(NSArray<VMKDataSource *> *)dataSources {
    self = [super init];
    if (self) {
        if (dataSources) {
            self.dataSources = [dataSources mutableCopy];
        }
    }
    return self;
}

#pragma mark - properties

- (NSMutableArray<VMKDataSource *> *)dataSources {
    if (_dataSources) {
        return _dataSources;
    }
    
    _dataSources = [[NSMutableArray alloc] init];
    return _dataSources;
}

- (void)setDataSources:(NSMutableArray<VMKDataSource *> *)dataSources {
    
    if (_dataSources != dataSources) {
        for (VMKDataSource *dataSource in _dataSources) {
            dataSource.delegate = nil;
        }
        
        _dataSources = dataSources;
        
        for (VMKDataSource *dataSource in _dataSources) {
            dataSource.delegate = self;
        }
    }
}

- (void)resetDataSources:(NSArray<VMKDataSource *> *)dataSources {
    self.dataSources = [dataSources mutableCopy];
}

#pragma mark - add

- (void)addDataSource:(VMKDataSource *)dataSource {
    [self insertDataSource:dataSource atIndex:self.dataSources.count];
}

- (void)insertDataSource:(VMKDataSource *)dataSource atIndex:(NSUInteger)index {
    dataSource.delegate = self;
    [self.dataSources insertObject:dataSource atIndex:index];
    
    VMKChangeSet *changeSet = [self changeSetForDataSource:dataSource isAdded:YES];
    [self dataSource:dataSource didUpdateChangeSet:changeSet];
}

#pragma mark - remove

- (void)removeDataSource:(VMKDataSource *)dataSource {
    
    VMKChangeSet *changeSet = [self changeSetForDataSource:dataSource isAdded:NO];
    [self mapChangeSet:changeSet withDataSource:dataSource];
    
    dataSource.delegate = nil;
    [self.dataSources removeObject:dataSource];
    
    [self.delegate dataSource:self didUpdateChangeSet:changeSet];
}

- (void)removeDataSourceAtIndex:(NSUInteger)index {
    VMKDataSource *dataSource = [self dataSourceAtIndex:index];
    if (dataSource) {
        [self removeDataSource:dataSource];
    }
}

#pragma mark - dataSource

- (VMKDataSource *)dataSourceAtIndex:(NSUInteger)index {
    if (index >= self.dataSources.count) {
        return nil;
    }

    return [self.dataSources objectAtIndex:index];
}

- (VMKDataSource *)dataSourceAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKMappedChildDataSourceIndexPath *dataSourceIndexPath = [self mappedChildDataSourceIndexPathForIndexPath:indexPath];
    
    return dataSourceIndexPath.dataSource;
}

#pragma mark - VMKDataSourceDelegate

- (void)dataSource:(VMKDataSource *)dataSource didUpdateChangeSet:(VMKChangeSet *)changeSet {
    
    [self mapChangeSet:changeSet withDataSource:dataSource];
    [self.delegate dataSource:self didUpdateChangeSet:changeSet];
}

#pragma mark - VMKDataSourceType editing

- (void)setEditing:(BOOL)editing {
    if (self.editing == editing) {
        return;
    }
    
    [super setEditing:editing];
    
    for (VMKDataSource *dataSource in self.dataSources) {
        if ([dataSource respondsToSelector:@selector(setEditing:)]) {
            [dataSource setEditing:editing];
        }
    }
}

#pragma mark - VMKDataSourceType

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForIndexPath:indexPath];
    NSIndexPath *mappedIndexPath = singleDataSource.indexPath;
    if (mappedIndexPath) {
        return [singleDataSource.dataSource viewModelAtIndexPath:mappedIndexPath];
    }
    return nil;
}

#pragma mark - internal helpers

- (VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForDataSource:(VMKDataSource *)dataSource {

    NSInteger offset = 0;
    VMKMappedChildDataSourceIndexPath *mappedDataSource = nil;
    for (VMKDataSource *sourceDataSource in self.dataSources) {
        if (sourceDataSource == dataSource) {
            mappedDataSource = [[VMKMappedChildDataSourceIndexPath alloc] initWithDataSource:dataSource offset:offset indexPath:nil];
            break;
        }
        offset += [self childOffsetForDataSource:sourceDataSource];
    }
    NSAssert(mappedDataSource, @"Datasource %@ doesnot exist", dataSource);
    return mappedDataSource;
}

- (VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForOffset:(NSInteger)offset {
    
    NSInteger current = 0;
    VMKMappedChildDataSourceIndexPath *mappedDataSource = nil;
    for (VMKDataSource *dataSource in self.dataSources) {
        NSInteger single = [self childOffsetForDataSource:dataSource];
        NSInteger max = current + single;
        
        if (offset >= current && offset < max) {
            NSInteger mappedOffset = offset - current;
            mappedDataSource = [[VMKMappedChildDataSourceIndexPath alloc] initWithDataSource:dataSource offset:mappedOffset indexPath:nil];
            break;
        }
        current = max;
    }
    NSAssert(mappedDataSource, @"DataSource doesnot exist for offset %ld", (long)offset);
    return mappedDataSource;
}

#pragma mark - internal mapping overwrite

- (NSInteger)childOffsetForDataSource:(VMKDataSource *)dataSource {
    return 0;
}

- (nullable VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)mapChangeSet:(VMKChangeSet *)changeSet withDataSource:(VMKDataSource *)dataSource {
}

- (VMKChangeSet *)changeSetForDataSource:(VMKDataSource *)dataSource isAdded:(BOOL)added {
    return [[VMKChangeSet alloc] init];
}

@end
