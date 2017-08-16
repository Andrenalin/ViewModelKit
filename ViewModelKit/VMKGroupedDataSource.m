//
//  VMKGroupedDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 10/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKGroupedDataSource+Private.h"

@implementation VMKGroupedDataSource

#pragma mark - init

- (instancetype)initWithDataSource:(VMKDataSource<VMKGroupedDataSourceType> *)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
    return self;
}

#pragma mark - properties

- (NSMutableArray *)groupedKeys {
    if (_groupedKeys) {
        return _groupedKeys;
    }
    _groupedKeys = [[self.dataSource groupedKeys] mutableCopy];
    return _groupedKeys;
}

- (VMKMultipleDataSource *)rowDataSource {
    if (_rowDataSource) {
        return _rowDataSource;
    }
    
    _rowDataSource = [[VMKMultiRowDataSource alloc] initWithDataSources:[self rowInitialDataSources]];
    _rowDataSource.delegate = self;
    
    return _rowDataSource;
}

- (NSMutableArray<VMKDataSource *> *)rowInitialDataSources {

    NSMutableArray<VMKDataSource *> *rowDataSources = [[NSMutableArray alloc] initWithCapacity:self.groupedKeys.count];
    
    for (id groupedKey in self.groupedKeys) {
        VMKDataSource *dataSource = [self.dataSource dataSourceForGroupedKey:groupedKey];
        [rowDataSources addObject:dataSource];
    }

    return rowDataSources;
}

#pragma mark - VMKDataSourceDelegate

- (void)dataSource:(VMKDataSource *)dataSource didUpdateChangeSet:(VMKChangeSet *)changeSet {
    
    if (dataSource == self.dataSource) {
        [self performSelector:@selector(doUpdate) withObject:nil afterDelay:0];
    } else {
        [self.delegate dataSource:self didUpdateChangeSet:changeSet];
    }
}

- (void)doUpdate {
    NSArray *changedKeys = [self.dataSource groupedKeys];
    NSMutableArray *insertedKeys = [changedKeys mutableCopy];
    [insertedKeys removeObjectsInArray:self.groupedKeys];
    
    NSMutableSet *deletedKeys = [NSMutableSet setWithArray:self.groupedKeys];
    [deletedKeys minusSet:[NSMutableSet setWithArray:changedKeys]];
    
    // delete
    for (id deletedKey in deletedKeys) {
        NSUInteger deletedIndex = [self.groupedKeys indexOfObject:deletedKey];
        
        [self.rowDataSource removeDataSourceAtIndex:deletedIndex];
        [self.groupedKeys removeObjectAtIndex:deletedIndex];
    }
    
    // insert
    for (id insertedKey in insertedKeys) {
        NSUInteger newIndex = [changedKeys indexOfObject:insertedKey];
        
        VMKDataSource *rowDataSource = [self.dataSource dataSourceForGroupedKey:insertedKey];
        [self.rowDataSource insertDataSource:rowDataSource atIndex:newIndex];
        [self.groupedKeys insertObject:insertedKey atIndex:newIndex];
    }
    
    // rearrange
    [self.groupedKeys enumerateObjectsUsingBlock:^(id _Nonnull groupedKey, NSUInteger oldIndex, BOOL * _Nonnull stop) {
        NSUInteger newIndex = [changedKeys indexOfObject:groupedKey];
        if (oldIndex != newIndex) {

            VMKDataSource *dataSource = [self.rowDataSource dataSourceAtIndex:oldIndex];
            [self.rowDataSource removeDataSourceAtIndex:oldIndex];
            [self.rowDataSource insertDataSource:dataSource atIndex:newIndex];
                        
            [self.groupedKeys replaceObjectAtIndex:oldIndex withObject:[changedKeys objectAtIndex:oldIndex]];
            [self.groupedKeys replaceObjectAtIndex:newIndex withObject:groupedKey];
        }
    }];
}

#pragma mark - VMKDataSourceType editing

- (void)setEditing:(BOOL)editing {
    if (self.editing == editing) {
        return;
    }
    
    [super setEditing:editing];
    
    [self.dataSource setEditing:editing];
    [self.rowDataSource setEditing:editing];
}

#pragma mark - VMKDataSourceType configuring

- (NSInteger)sections {
    return self.rowDataSource.sections;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    return [self.rowDataSource rowsInSection:section];
}

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    return [self.rowDataSource viewModelAtIndexPath:indexPath];
}

#pragma mark - VMKDataSourceType section header / footer

- (nullable VMKViewModel<VMKHeaderFooterType> *)headerViewModelAtSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(headerViewModelAtSection:)]) {
        return [self.dataSource headerViewModelAtSection:section];
    }
    return nil;
}

- (nullable NSString *)titleForHeaderInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(titleForHeaderInSection:)]) {
        return [self.dataSource titleForHeaderInSection:section];
    }
    return nil;
}

- (nullable NSString *)titleForFooterInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(titleForFooterInSection:)]) {
        return [self.dataSource titleForFooterInSection:section];
    }
    return nil;
}

#pragma mark - VMKDataSourceType section index

- (nullable NSArray<NSString *> *)sectionIndexTitles {
    if ([self.dataSource respondsToSelector:@selector(sectionIndexTitles)]) {
        return [self.dataSource sectionIndexTitles];
    }
    return nil;
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(sectionForSectionIndexTitle:atIndex:)]) {
        return [self.dataSource sectionForSectionIndexTitle:title atIndex:index];
    }
    return -1;
}

@end
