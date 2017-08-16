//
//  VMKMutableArrayDataSource+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 04/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKMutableArrayDataSource.h"

#import "VMKArrayUpdater.h"
#import "VMKChangeSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKMutableArrayDataSource () <VMKArrayUpdaterDelegate>
@property (nonatomic, strong) VMKArrayModel *arrayModel;
@property (nonatomic, strong, readwrite) VMKViewModelCache *viewModelCache;
@property (nonatomic, strong) VMKArrayUpdater *arrayUpdater;
@end

NS_ASSUME_NONNULL_END
