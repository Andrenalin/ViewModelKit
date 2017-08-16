//
//  VMKGroupedDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 10/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKGroupedDataSourceType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKGroupedDataSource : VMKDataSource
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(VMKDataSource<VMKGroupedDataSourceType> *)dataSource NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
