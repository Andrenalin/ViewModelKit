//
//  VMKCoreDataViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 24/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import CoreData;

#import "VMKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKCoreDataViewModel<__covariant CoreDataType: __kindof NSManagedObject *> : VMKViewModel<CoreDataType>

- (BOOL)saveCoreDataObject:(NSError *__autoreleasing *)error;
- (void)resetObject:(nullable CoreDataType)object;
- (void)deleteObject;
@end

NS_ASSUME_NONNULL_END
