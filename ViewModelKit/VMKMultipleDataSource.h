//
//  VMKMultipleDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKMappedChildDataSourceIndexPath.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKMultipleDataSource : VMKDataSource
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSources:(nullable NSArray<VMKDataSource *> *)dataSources;

// does not generate any changeset, only for the init in subclassing 
- (void)resetDataSources:(NSArray<VMKDataSource *> *)dataSources;

- (void)addDataSource:(VMKDataSource *)dataSource;
- (void)insertDataSource:(VMKDataSource *)dataSource atIndex:(NSUInteger)index;

- (void)removeDataSource:(VMKDataSource *)dataSource;
- (void)removeDataSourceAtIndex:(NSUInteger)index;

- (nullable VMKDataSource *)dataSourceAtIndex:(NSUInteger)index;

- (nullable VMKDataSource *)dataSourceAtIndexPath:(NSIndexPath *)indexPath;
- (nullable VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
