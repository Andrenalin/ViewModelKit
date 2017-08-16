//
//  VMKSingleChange.h
//  ViewModelKit
//
//  Created by Andre Trettin on 13/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VMKSingleChangeType) {
    VMKSingleChangeTypeSectionInserted,
    VMKSingleChangeTypeSectionDeleted,
    VMKSingleChangeTypeSectionChanged,
    VMKSingleChangeTypeRowInserted,
    VMKSingleChangeTypeRowDeleted,
    VMKSingleChangeTypeRowChanged,
    VMKSingleChangeTypeRowMoved,
};

@interface VMKSingleChange : NSObject
@property (nonatomic, assign, readonly) VMKSingleChangeType type;

@property (nonatomic, assign, readonly) NSUInteger section;
@property (nonatomic, strong, nullable, readonly) NSIndexPath *rowIndexPath;
@property (nonatomic, strong, nullable, readonly) NSIndexPath *movedToRowIndexPath;

// convience getters
@property (nonatomic, strong, readonly) NSIndexSet *sectionSet;
@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *rows;
@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *movedToRows;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)isEqualToSingleChange:(nullable VMKSingleChange *)other;

// section types
- (instancetype)initWithChangedSection:(NSUInteger)section;
- (instancetype)initWithInsertedSection:(NSUInteger)section;
- (instancetype)initWithDeletedSection:(NSUInteger)section;

// row types
- (instancetype)initWithChangedRow:(NSIndexPath *)rowIndexPath;
- (instancetype)initWithInsertedRow:(NSIndexPath *)rowIndexPath;
- (instancetype)initWithDeletedRow:(NSIndexPath *)rowIndexPath;
- (instancetype)initWithMovedRow:(NSIndexPath *)rowIndexPath to:(NSIndexPath *)moveToRowIndexPath;

// offset
- (void)applySectionOffset:(NSInteger)sectionOffset rowOffset:(NSInteger)rowOffset;
@end

NS_ASSUME_NONNULL_END
