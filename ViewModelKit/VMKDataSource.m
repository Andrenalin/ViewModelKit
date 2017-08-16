//
//  VMKDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKDataSource.h"
#import "VMKInsertCellViewModel.h"

@implementation VMKDataSource

#pragma mark - VMKDataSourceDelegate

- (void)dataSource:(VMKDataSource *)dataSource didUpdateChangeSet:(VMKChangeSet *)changeSet {
    [self.delegate dataSource:self didUpdateChangeSet:changeSet];
}

#pragma mark - VMKDataSourceType configuring

- (NSInteger)sections {
    // nothing to do --> implemented by the subclass
    return 0;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    // nothing to do --> implemented by the subclass
    return 0;
}

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - inserting or deleting rows

- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:indexPath];
    if ([viewModel respondsToSelector:@selector(canEdit)]) {
        return viewModel.canEdit;
    }
    return NO;
}

- (void)deleteAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:indexPath];
    if ([viewModel respondsToSelector:@selector(deleteData)]) {
        [viewModel deleteData];
    }
}

- (void)insertAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:indexPath];
    if ([viewModel isKindOfClass:[VMKInsertCellViewModel class]]) {
        VMKInsertCellViewModel *ivm = (VMKInsertCellViewModel *)viewModel;
        [ivm insertData];
    } else {
        [NSException raise:@"expected insert cell" format:@"view model is not kind of insert cell viewmodel"];
    }
}

#pragma mark - reordering rows

- (BOOL)canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:indexPath];
    if ([viewModel respondsToSelector:@selector(canMove)]) {
        return viewModel.canMove;
    }
    return NO;
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:sourceIndexPath];
    if ([viewModel respondsToSelector:@selector(moveToIndexPath:)]) {
        [viewModel moveToIndexPath:destinationIndexPath];
    }
}

@end
