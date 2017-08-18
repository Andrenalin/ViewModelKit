//
//  VMKCollectionViewDataSource.h
//  ViewModelKit
//
//  Created by Daniel Rinser on 03.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKDataSource.h"
#import "VMKCollectionViewDataSourceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKCollectionViewDataSource : NSObject <UICollectionViewDataSource>
@property (strong, nonatomic, nullable) VMKDataSource *dataSource;
@property (weak, nonatomic) id<VMKCollectionViewDataSourceDelegate> delegate;
@property (assign, nonatomic) BOOL editing;

- (instancetype)initWithDataSource:(nullable VMKDataSource *)dataSource NS_DESIGNATED_INITIALIZER;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (nullable __kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(nonnull NSIndexPath *)indexPath;
// TODO: support supplementatry views
@end

NS_ASSUME_NONNULL_END
