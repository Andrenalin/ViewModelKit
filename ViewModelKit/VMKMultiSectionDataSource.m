//
//  VMKMultiSectionDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 11/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKMultiSectionDataSource.h"
#import "VMKMultipleDataSource+Private.h"

#import "VMKChangeSet.h"

@implementation VMKMultiSectionDataSource

#pragma mark - VMKDataSourceType

- (NSInteger)sections {
    
    NSInteger sections = 0;
    for (VMKDataSource *dataSource in self.dataSources) {
        sections += [dataSource sections];
    }
    
    return sections;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    
    if ([self sections] == 0) {
        return 0;
    }
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForOffset:section];
    return [singleDataSource.dataSource rowsInSection:singleDataSource.offset];
}

#pragma mark - VMKDataSourceType section header / footer

- (nullable VMKViewModel<VMKHeaderFooterType> *)headerViewModelAtSection:(NSInteger)section {
    
    if ([self sections] == 0) {
        return nil;
    }
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForOffset:section];
    if ([singleDataSource.dataSource respondsToSelector:@selector(headerViewModelAtSection:)]) {
        return [singleDataSource.dataSource headerViewModelAtSection:singleDataSource.offset];
    }
    
    return nil;
}

- (nullable NSString *)titleForHeaderInSection:(NSInteger)section {

    if ([self sections] == 0) {
        return nil;
    }
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForOffset:section];
    if ([singleDataSource.dataSource respondsToSelector:@selector(titleForHeaderInSection:)]) {
        return [singleDataSource.dataSource titleForHeaderInSection:singleDataSource.offset];
    }
    return nil;
}

- (nullable NSString *)titleForFooterInSection:(NSInteger)section {
    
    if ([self sections] == 0) {
        return nil;
    }
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForOffset:section];
    if ([singleDataSource.dataSource respondsToSelector:@selector(titleForFooterInSection:)]) {
        return [singleDataSource.dataSource titleForFooterInSection:singleDataSource.offset];
    }
    return nil;
}

#pragma mark - VMKDataSourceType section index

- (nullable NSArray<NSString *> *)sectionIndexTitles {
    
    NSMutableArray<NSString *> *titles = nil;
    for (VMKDataSource *dataSource in self.dataSources) {
        if ([dataSource respondsToSelector:@selector(sectionIndexTitles)]) {
            NSArray<NSString *> *partTitles = [dataSource sectionIndexTitles];
            if (!partTitles) {
                continue;
            }
            
            if (!titles) {
                titles = [[NSMutableArray alloc] init];
            }
            [titles addObjectsFromArray:partTitles];
        }
    }
    return titles;
}

// TODO: testing... mapping is missing and checks
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    for (VMKDataSource *dataSource in self.dataSources) {
        if ([dataSource respondsToSelector:@selector(sectionForSectionIndexTitle:atIndex:)]) {
            NSInteger i = [dataSource sectionForSectionIndexTitle:title atIndex:index];
            if (i >= 0) {
                return i;
            }
        }
    }
    return -1;
}

#pragma mark - internal mapping

- (NSInteger)childOffsetForDataSource:(VMKDataSource *)dataSource {
    return [dataSource sections];
}

- (nullable VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForIndexPath:(NSIndexPath *)indexPath {
    VMKMappedChildDataSourceIndexPath *sectionDataSource = [self mappedChildDataSourceIndexPathForOffset:indexPath.section];
    sectionDataSource.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:sectionDataSource.offset];
    return sectionDataSource;
}

- (void)mapChangeSet:(VMKChangeSet *)changeSet withDataSource:(VMKDataSource *)dataSource {
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForDataSource:dataSource];
    [changeSet applySectionOffset:singleDataSource.offset rowOffset:0];
}

- (VMKChangeSet *)changeSetForDataSource:(VMKDataSource *)dataSource isAdded:(BOOL)added {
    VMKChangeSet *changeSet = [[VMKChangeSet alloc] init];
    for (NSUInteger section = 0; section < (NSUInteger)[dataSource sections]; ++section) {
        if (added) {
            [changeSet insertedSectionAtIndex:section];
        } else {
            [changeSet deletedSectionAtIndex:section];
        }
    }
    return changeSet;
}

@end
