//
//  VMKArrayDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 13.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import UIKit;  // need for NSIndexpath.row

#import "VMKArrayDataSource+Private.h"

@implementation VMKArrayDataSource

#pragma mark - init 

- (instancetype)init {
    return [self initWithViewModels:nil];
}

- (instancetype)initWithViewModels:(NSArray<__kindof VMKViewModel<VMKCellType> *> *)viewModels {
    self = [super init];
    if (self) {
        _viewModels = [viewModels copy];
    }
    return self;
}

- (void)resetViewModels:(NSArray<VMKViewModel<VMKCellType> *> *)viewModels {
    self.viewModels = viewModels;
}

#pragma mark - VMKDataSourceType

- (NSInteger)sections {
    return 1;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    NSAssert(section == 0, @"Section can be only zero, section is %ld", (long)section);
    return (NSInteger)self.viewModels.count;
}

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath.section == 0, @"Section can be only zero, section is %ld", (long)indexPath.section);
    return [self.viewModels objectAtIndex:(NSUInteger)indexPath.row];
}

- (nullable VMKViewModel<VMKHeaderFooterType> *)headerViewModelAtSection:(NSInteger)section {
    NSAssert(section == 0, @"Section can be only zero, section is %ld", (long)section);
    return self.headerViewModel;
}

@end
