//
//  VMKEditDataSource+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 20/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKEditDataSource.h"
#import "VMKMultipleDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKEditDataSource ()
@property (strong, nonatomic, nonnull) VMKMultipleDataSource *dataSource;
@property (strong, nonatomic, nonnull) VMKDataSource * editDataSource;
@end

NS_ASSUME_NONNULL_END
