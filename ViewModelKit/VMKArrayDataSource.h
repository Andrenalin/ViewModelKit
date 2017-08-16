//
//  VMKArrayDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 13.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKArrayDataSource : VMKDataSource
@property (nonatomic, strong, nullable) VMKViewModel<VMKHeaderFooterType> *headerViewModel;

- (instancetype)init;
- (instancetype)initWithViewModels:(nullable NSArray<__kindof VMKViewModel<VMKCellType> *> *)viewModels NS_DESIGNATED_INITIALIZER;

- (void)resetViewModels:(nullable NSArray<VMKViewModel<VMKCellType> *> *)viewModels;
@end

NS_ASSUME_NONNULL_END
