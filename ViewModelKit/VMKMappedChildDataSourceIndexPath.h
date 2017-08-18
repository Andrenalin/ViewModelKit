//
//  VMKMappedChildDataSourceIndexPath.h
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKMappedChildDataSourceIndexPath : NSObject
@property (nonatomic, strong, readonly) VMKDataSource *dataSource;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(VMKDataSource *)dataSource offset:(NSInteger)offset indexPath:(nullable NSIndexPath *)indexPath NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
