//
//  VMKDataSourceViewModelType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 23.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

@class VMKDataSource;

#import "VMKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKDataSourceViewModelType
@property (nonatomic, strong, readonly) __kindof VMKDataSource *dataSource;
@end

NS_ASSUME_NONNULL_END
