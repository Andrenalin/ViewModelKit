//
//  VMKTableViewDelegate.m
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKTableViewDelegate.h"
#import "VMKViewModel.h"
#import "VMKCellType.h"
#import "VMKTableViewDataSource.h"
#import "VMKTableViewRowActionCreator.h"

@implementation VMKTableViewDelegate

- (VMKTableViewDataSource *)dataSourceFromTableView:(UITableView *)tableView {

    if ([tableView.dataSource isKindOfClass:[VMKTableViewDataSource class]]) {
        return tableView.dataSource;
    }
    return nil;
}

#pragma mark - Modifying the Header and Footer of Sections

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    VMKTableViewDataSource *dataSource = [self dataSourceFromTableView:tableView];
    return [dataSource tableView:tableView headerViewAtSection:section];
}


#pragma mark - Editing Table Rows

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    VMKTableViewDataSource *dataSource = [self dataSourceFromTableView:tableView];
    VMKViewModel<VMKCellType> *cvm = [dataSource viewModelAtIndexPath:indexPath];
    
    if ([cvm respondsToSelector:@selector(canInsert)]) {
        if ([cvm canInsert]) {
            return UITableViewCellEditingStyleInsert;
        }
    }
    
    if ([cvm respondsToSelector:@selector(canDelete)]) {
        if ([cvm canDelete]) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

// TODO: this delegate should be handled by the data source or model.
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toProposedIndexPath:(nonnull NSIndexPath *)proposedDestinationIndexPath {
    
    if ([self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        
        NSIndexPath *indexPath = [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
        return indexPath;
    }
    return proposedDestinationIndexPath;
}

#pragma mark - Managing Accessory Views

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VMKTableViewDataSource *dataSource = [self dataSourceFromTableView:tableView];
    VMKViewModel<VMKCellType> *cvm = [dataSource viewModelAtIndexPath:indexPath];
    
    if ([cvm respondsToSelector:@selector(rowActions)]) {
        id<VMKTableViewRowActionsType> rowActionsType = [cvm rowActions];
        if (rowActionsType) {
            VMKTableViewRowActionCreator *creator = [[VMKTableViewRowActionCreator alloc] initWithTableView:tableView rowActionsType:rowActionsType];
            return [creator tableViewRowActions];
        }
    }
    return nil;
}

#pragma mark - Forwarding unhandled methods to real delegate

- (id)forwardingTargetForSelector:(SEL)selector {
    // forward everything that we don't explicitly intercept to the real delegate
    if ([self.delegate respondsToSelector:selector]) {
        return self.delegate;
    }
    
    return nil;
}

- (BOOL)respondsToSelector:(SEL)selector {
    // we also need to return true if our delegate responds to the selector (because we'll be forwarding it there)
    return [super respondsToSelector:selector] || [self.delegate respondsToSelector:selector];
}

@end
