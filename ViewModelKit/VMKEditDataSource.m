//
//  VMKEditDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 23/01/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKEditDataSource+Private.h"

#import "VMKMultiRowDataSource.h"
#import "VMKMultiSectionDataSource.h"

@implementation VMKEditDataSource

#pragma mark - init

- (instancetype)initWithDataSource:(VMKDataSource *)dataSource editDataSource:(VMKDataSource *)editDataSource editAsSection:(BOOL)editAsSection {
    self = [super init];
    if (self) {
        if (editAsSection) {
            _dataSource = [[VMKMultiSectionDataSource alloc] initWithDataSources:@[ dataSource ]];
        } else {
            _dataSource = [[VMKMultiRowDataSource alloc] initWithDataSources:@[ dataSource ]];
        }
        _dataSource.delegate = self;
        _editDataSource = editDataSource;
    }
    return self;
}

#pragma mark - VMKDataSourceType editing

- (void)setEditing:(BOOL)editing {
    if (self.editing == editing) {
        return;
    }
    
    [super setEditing:editing];
    
    if (!self.editing) {
        [self.dataSource removeDataSource:self.editDataSource];
    }
    
    [self.dataSource setEditing:editing];
    
    if (self.editing) {
        [self.dataSource addDataSource:self.editDataSource];
    }
}

#pragma mark - VMKDataSourceType

- (NSInteger)sections {
    return [self.dataSource sections];
}

- (NSInteger)rowsInSection:(NSInteger)section {
    return [self.dataSource rowsInSection:section];
}

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource viewModelAtIndexPath:indexPath];
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
