//
//  VMKCollectionViewDataSourceDelegate.h
//  ViewModelKit
//
//  Created by Daniel Rinser on 03.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKCellType.h"
#import "VMKHeaderFooterType.h"

@class VMKCollectionViewDataSource;
@class VMKChangeSet;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKCollectionViewDataSourceDelegate <NSObject>

- (NSString *)dataSource:(VMKCollectionViewDataSource *)dataSource cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (void)dataSource:(VMKCollectionViewDataSource *)dataSource configureCell:(UICollectionViewCell *)cell withViewModel:(__kindof VMKViewModel<VMKCellType> *)viewModel;

- (void)dataSource:(VMKCollectionViewDataSource *)dataSource didChangeWithChangeSet:(VMKChangeSet *)changeSet;

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

@optional

- (nonnull NSString *)dataSource:(VMKCollectionViewDataSource *)dataSource supplementaryViewOfKindElement:(NSString *)kind atIndex:(NSIndexPath *)indexPath;

- (void)dataSource:(VMKCollectionViewDataSource *)dataSource configureHeaderView:(UICollectionReusableView *)headerView withViewModel:(__kindof VMKViewModel<VMKHeaderFooterType> *)viewModel;

@end

NS_ASSUME_NONNULL_END
