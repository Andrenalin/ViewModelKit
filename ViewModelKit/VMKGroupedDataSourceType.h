//
//  VMKGroupedDataSourceType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 11/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKGroupedDataSourceType <NSObject>
- (VMKDataSource *)dataSourceForGroupedKey:(id)groupedKey;

- (NSArray *)groupedKeys;
@end

NS_ASSUME_NONNULL_END
