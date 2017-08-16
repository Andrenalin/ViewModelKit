//
//  VMKSingleChange+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 13/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKSingleChange.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKSingleChange ()
@property (nonatomic, assign, readwrite) VMKSingleChangeType type;

@property (nonatomic, assign, readwrite) NSUInteger section;
@property (nonatomic, strong, nullable, readwrite) NSIndexPath *rowIndexPath;
@property (nonatomic, strong, nullable, readwrite) NSIndexPath *movedToRowIndexPath;
@end

NS_ASSUME_NONNULL_END
