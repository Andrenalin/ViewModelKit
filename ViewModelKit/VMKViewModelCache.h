//
//  VMKViewModelCache.h
//  ViewModelKit
//
//  Created by Andre Trettin on 03.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

@class VMKViewModel;
@class VMKChangeSet;

NS_ASSUME_NONNULL_BEGIN

@interface VMKViewModelCache : NSObject
- (nullable __kindof VMKViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath;
- (void)setViewModel:(__kindof VMKViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

- (void)changeCacheWithChangeSet:(VMKChangeSet *)changeSet;
- (void)resetCache;
@end

NS_ASSUME_NONNULL_END
