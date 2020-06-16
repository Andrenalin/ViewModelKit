//
//  VMKCollectionViewDataSource.m
//  ViewModelKit
//
//  Created by Daniel Rinser on 03.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKCollectionViewDataSource+Private.h"

@implementation VMKCollectionViewDataSource

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

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource rowsInSection:section];
}

- (nullable __kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource viewModelAtIndexPath:indexPath];
}

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.delegate requestViewWithViewModel:viewModel atIndexPath:indexPath];
}

#pragma mark - VMKDataSourceDelegate

- (void)dataSource:(VMKDataSource *)dataSource didUpdateChangeSet:(VMKChangeSet *)changeSet {
    if ([self.delegate respondsToSelector:@selector(dataSource:didChangeWithChangeSet:)]) {
        [self.delegate dataSource:self didChangeWithChangeSet:changeSet];
    }
}

#pragma mark - UICollectionViewDataSource Configuring

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

#pragma mark - UICollectionViewDataSource Views

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.delegate dataSource:self cellIdentifierAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    __kindof VMKViewModel<VMKCellType> *viewModel = [self viewModelAtIndexPath:indexPath];
    if (viewModel) {
        [self.delegate dataSource:self configureCell:cell withViewModel:viewModel];
    }
}

// TODO: Supplementary Views

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView = [UICollectionReusableView new];
    supplementaryView.hidden = YES;
    
    if ([self.delegate respondsToSelector: @selector(dataSource:supplementaryViewOfKindElement:atIndex:)]) {
        NSString *reuseID = [self.delegate dataSource: self supplementaryViewOfKindElement: kind atIndex: indexPath];
        
        if (reuseID && kind == UICollectionElementKindSectionHeader) {
            supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: reuseID forIndexPath: indexPath];
            
            __kindof VMKViewModel<VMKHeaderFooterType> *viewModel = [self viewModelAtIndexPath:indexPath];
            if (viewModel) {
                //only called if underlying object implements supplementaryViewOfKindElement:
                [self.delegate dataSource: self configureHeaderView: supplementaryView withViewModel: viewModel];
            }
        }
    }
    return supplementaryView;
}

#pragma mark - UICollectionViewDataSource Reordering

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource canMoveRowAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [self.dataSource moveRowAtIndexPath:sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath];
}

@end
