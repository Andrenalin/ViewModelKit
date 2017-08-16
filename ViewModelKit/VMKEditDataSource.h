//
//  VMKEditDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 23/01/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKEditDataSource : VMKDataSource
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(VMKDataSource *)dataSource editDataSource:(VMKDataSource *)editDataSource editAsSection:(BOOL)editAsSection NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
