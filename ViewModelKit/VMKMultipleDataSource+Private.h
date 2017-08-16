//
//  VMKMultipleDataSource+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 11/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKMultipleDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKMultipleDataSource ()
@property (strong, nonatomic) NSMutableArray<VMKDataSource *> *dataSources;

- (nullable VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForDataSource:(VMKDataSource *)dataSource;
- (nullable VMKMappedChildDataSourceIndexPath *)mappedChildDataSourceIndexPathForOffset:(NSInteger)offset;

#pragma mark - overwirte in subclassing

- (NSInteger)childOffsetForDataSource:(VMKDataSource *)dataSource;
- (void)mapChangeSet:(VMKChangeSet *)changeSet withDataSource:(VMKDataSource *)dataSource;
- (VMKChangeSet *)changeSetForDataSource:(VMKDataSource *)dataSource isAdded:(BOOL)added;
@end

NS_ASSUME_NONNULL_END
