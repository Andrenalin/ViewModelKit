//
//  VMKTableViewDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 25.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKTableViewDataSource+Private.h"
#import "VMKTableViewCell.h"

@implementation VMKTableViewDataSource

#pragma mark - init

- (instancetype)init {
    return [self initWithDataSource:nil];
}

- (instancetype)initWithDataSource:(VMKDataSource *)dataSource {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

#pragma mark - properties

- (void)setDataSource:(VMKDataSource *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource.delegate = nil;
        
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
}

- (void)setEditing:(BOOL)editing {
    if (_editing != editing) {
        _editing = editing;
        [self.dataSource setEditing:editing];
    }
}

#pragma mark - public interface

- (NSInteger)numberOfSections {
    return [self.dataSource sections];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource rowsInSection:section];
}

- (nullable __kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource viewModelAtIndexPath:indexPath];
}

- (nullable VMKViewModel<VMKHeaderFooterType> *)headerViewModelAtSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(headerViewModelAtSection:)]) {
        return [self.dataSource headerViewModelAtSection:section];
    }
    return nil;
}

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.delegate requestViewWithViewModel:viewModel atIndexPath:indexPath];
}

#pragma mark - VMDataSourceDelegate

- (void)dataSource:(VMKDataSource *)dataSource didUpdateChangeSet:(VMKChangeSet *)changeSet {
    [self.delegate dataSource:self didChangeWithChangeSet:changeSet];
}

#pragma mark - UITableViewDataSource Configuring

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource sections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource rowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.delegate dataSource:self cellIdentifierAtIndexPath:indexPath];
    NSAssert(cellIdentifier, @"Cell identifier must be set");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    __kindof VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:indexPath];
    if (viewModel) {
        [self.delegate dataSource:self configureCell:cell withViewModel:viewModel];
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *header = nil;
    if ([self.dataSource respondsToSelector:@selector(titleForHeaderInSection:)]) {
        header = [self.dataSource titleForHeaderInSection:section];
    }

    if (!header) {
        if ([self.delegate respondsToSelector:@selector(dataSource:titleForHeaderInSection:)]) {
            header = [self.delegate dataSource:self titleForHeaderInSection:section];
        }
    }
    
    return header;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSString *footer = nil;
    if ([self.dataSource respondsToSelector:@selector(titleForFooterInSection:)]) {
        footer = [self.dataSource titleForFooterInSection:section];
    }
    
    if (!footer) {
        if ([self.delegate respondsToSelector:@selector(dataSource:titleForFooterInSection:)]) {
            footer = [self.delegate dataSource:self titleForFooterInSection:section];
        }
    }
    
    return footer;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(sectionIndexTitles)]) {
        return [self.dataSource sectionIndexTitles];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(sectionForSectionIndexTitle:atIndex:)]) {
        return [self.dataSource sectionForSectionIndexTitle:title atIndex:index];
    }
    return -1;
}

#pragma mark - UITableViewDataSource Inserting or Deleting

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource canEditRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource deleteAtIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.dataSource insertAtIndexPath:indexPath];
    }
}

#pragma mark Reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource canMoveRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dataSource moveRowAtIndexPath:sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath];
}

#pragma mark - UITableViewDelegate Modifying the Header and Footer of Sections

- (nullable UIView<VMKViewHeaderFooterType> *)tableView:(UITableView *)tableView headerViewAtSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerFooterView = nil;
    VMKViewModel<VMKHeaderFooterType> *viewModel = [self headerViewModelAtSection:section];
    if (viewModel) {
        NSString *headerFooterViewIdentifier = [self.delegate dataSource:self headerViewIdentifierAtSection:section];
        if (headerFooterViewIdentifier) {
            headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewIdentifier];
            [self.delegate dataSource:self configureHeaderView:headerFooterView withViewModel:viewModel];
        }
    }
    
    return (__kindof UIView<VMKViewCellType> *)headerFooterView;
}

@end
