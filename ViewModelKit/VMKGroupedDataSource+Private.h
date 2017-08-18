//
//  VMKGroupedDataSource+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 19/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKGroupedDataSource.h"
#import "VMKMultiRowDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKGroupedDataSource ()
@property (nonatomic, strong) VMKDataSource<VMKGroupedDataSourceType> *dataSource;
@property (nonatomic, strong) NSMutableArray *groupedKeys;
@property (nonatomic, strong) VMKMultiRowDataSource *rowDataSource;

- (void)doUpdate;
@end

NS_ASSUME_NONNULL_END
