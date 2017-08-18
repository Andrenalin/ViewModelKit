//
//  VMKChangeSet.h
//  ViewModelKit
//
//  Created by Andre Trettin on 03.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

@class VMKSingleChange;

NS_ASSUME_NONNULL_BEGIN

@interface VMKChangeSet : NSObject <NSCopying>
@property (nonatomic, strong, readonly) NSMutableArray<VMKSingleChange *> *history;

- (BOOL)isEqualToChangeSet:(nullable VMKChangeSet *)other;

- (nullable NSIndexPath *)changedIndexPathForPreviousIndexPath:(nullable NSIndexPath *)indexPath;

// changes
- (void)insertedSectionAtIndex:(NSUInteger)index;
- (void)deletedSectionAtIndex:(NSUInteger)index;
- (void)changedSectionAtIndex:(NSUInteger)index;

- (void)insertedRowAtIndexPath:(nullable NSIndexPath *)indexPath;
- (void)deletedRowAtIndexPath:(nullable NSIndexPath *)indexPath;
- (void)changedRowAtIndexPath:(nullable NSIndexPath *)indexPath;
- (void)movedRowAtIndexPath:(nullable NSIndexPath *)indexPath toIndexPath:(nullable NSIndexPath *)toIndexPath;

// modify history
- (void)applySectionOffset:(NSInteger)sectionOffset rowOffset:(NSInteger)rowOffset;
- (void)cleanUp;
@end

NS_ASSUME_NONNULL_END
