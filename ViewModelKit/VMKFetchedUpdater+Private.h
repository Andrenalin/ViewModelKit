//
//  VMKFetchedUpdater+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 14/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKFetchedUpdater.h"
#import "VMKChangeSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKFetchedUpdater ()
@property (nonatomic, strong, nullable) VMKChangeSet *changeSet;
@end

NS_ASSUME_NONNULL_END
