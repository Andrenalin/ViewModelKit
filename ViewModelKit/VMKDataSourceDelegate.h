//
//  VMKDataSourceDelegate.h
//  ViewModelKit
//
//  Created by Andre Trettin on 20.01.16.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

@class VMKChangeSet;
@class VMKDataSource;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKDataSourceDelegate <NSObject>
- (void)dataSource:(VMKDataSource *)dataSource didUpdateChangeSet:(VMKChangeSet *)changeSet;
@end

NS_ASSUME_NONNULL_END
