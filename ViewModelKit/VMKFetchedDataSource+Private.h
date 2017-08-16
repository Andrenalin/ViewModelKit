//
//  VMKFetchedDataSource+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 03/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKFetchedDataSource.h"

#import "VMKFetchedUpdater.h"
#import "VMKChangeSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKFetchedDataSource () <VMKFetchedUpdaterDelegate>
@property (nonatomic, strong, readwrite) VMKViewModelCache *viewModelCache;
@property (nonatomic, strong) VMKFetchedUpdater *fetchedUpdater;
@end

NS_ASSUME_NONNULL_END
