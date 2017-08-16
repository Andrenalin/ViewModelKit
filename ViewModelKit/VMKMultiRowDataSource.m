//
//  VMKMultiRowDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 11/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKMultiRowDataSource.h"
#import "VMKMultipleDataSource+Private.h"

#import "VMKChangeSet.h"

@implementation VMKMultiRowDataSource

#pragma mark - VMKDataSourceType

- (NSInteger)sections {
    return 1;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    
    NSAssert(section == 0, @"There is only one section in a MultiRowDataSource. You tried to access section: %ld", (long)section);
    
    NSInteger rows = 0;
    for (VMKDataSource *dataSource in self.dataSources) {
        rows += [dataSource rowsInSection:0];
    }
    
    return rows;
}

#pragma mark - internal mapping

- (NSInteger)childOffsetForDataSource:(VMKDataSource *)dataSource {
    return [dataSource rowsInSection:0];
}

- (nullable VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert(indexPath.section == 0, @"The section %ld must be zero in a MultiRowDataSource", (long)indexPath.section);
    VMKMappedChildDataSourceIndexPath *rowDataSource = [self mappedChildDataSourceIndexPathForOffset:indexPath.row];
    rowDataSource.indexPath = [NSIndexPath indexPathForRow:rowDataSource.offset inSection:0];
    return rowDataSource;
}

- (void)mapChangeSet:(VMKChangeSet *)changeSet withDataSource:(VMKDataSource *)dataSource {
    
    VMKMappedChildDataSourceIndexPath *singleDataSource = [self mappedChildDataSourceIndexPathForDataSource:dataSource];
    [changeSet applySectionOffset:0 rowOffset:singleDataSource.offset];
}

- (VMKChangeSet *)changeSetForDataSource:(VMKDataSource *)dataSource isAdded:(BOOL)added {
    VMKChangeSet *changeSet = [[VMKChangeSet alloc] init];
    for (NSUInteger row = 0; row < (NSUInteger)[dataSource rowsInSection:0]; ++row) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
        if (added) {
            [changeSet insertedRowAtIndexPath:indexPath];
        } else {
            [changeSet deletedRowAtIndexPath:indexPath];
        }
    }
    return changeSet;
}

@end
