//
//  VMKMutableArrayDataSource.h
//  ViewModelKit
//
//  Created by Daniel Rinser on 09.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKDataSource.h"
#import "VMKViewModelCache.h"
#import "VMKArrayModel.h"
#import "VMKCellViewModelFactory.h"

@class VMKMutableArrayDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface VMKMutableArrayDataSource : VMKDataSource
@property (nonatomic, weak) id<VMKCellViewModelFactory> factory;
@property (nonatomic, strong, readonly) VMKViewModelCache *viewModelCache;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithArrayModel:(VMKArrayModel *)arrayModel factory:(nullable id<VMKCellViewModelFactory>)factory NS_DESIGNATED_INITIALIZER;

- (void)setUpBinding;
@end

NS_ASSUME_NONNULL_END
