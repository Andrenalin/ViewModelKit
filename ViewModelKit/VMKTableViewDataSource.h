//
//  VMKTableViewDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 25.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKDataSource.h"
#import "VMKTableViewDataSourceDelegate.h"
#import "VMKViewHeaderFooterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewDataSource : NSObject <UITableViewDataSource>
@property (strong, nonatomic, nullable) VMKDataSource *dataSource;
@property (weak, nonatomic) id<VMKTableViewDataSourceDelegate> delegate;
@property (assign, nonatomic) BOOL editing;

- (instancetype)initWithDataSource:(nullable VMKDataSource *)dataSource NS_DESIGNATED_INITIALIZER;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (nullable __kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable VMKViewModel<VMKHeaderFooterType> *)headerViewModelAtSection:(NSInteger)section;

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

- (nullable UIView<VMKViewHeaderFooterType> *)tableView:(UITableView *)tableView headerViewAtSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
