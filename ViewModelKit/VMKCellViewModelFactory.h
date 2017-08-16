//
//  VMKCellViewModelFactory.h
//  ViewModelKit
//
//  Created by Andre Trettin on 20.01.16.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKCellType.h"

@class VMKDataSource;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKCellViewModelFactory <NSObject>
- (nullable __kindof VMKViewModel<VMKCellType> *)cellViewModelForDataSource:(VMKDataSource *)dataSource object:(id)object;
@end

NS_ASSUME_NONNULL_END
