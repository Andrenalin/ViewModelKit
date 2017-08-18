//
//  VMKChangeSet+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 24/01/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKChangeSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKChangeSet ()
@property (nonatomic, strong, readwrite) NSMutableArray<VMKSingleChange *> *history;
@end

NS_ASSUME_NONNULL_END
