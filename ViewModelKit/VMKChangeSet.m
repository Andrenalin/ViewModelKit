//
//  VMKChangeSet.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKChangeSet+Private.h"
#import "VMKSingleChange+Private.h"

@implementation VMKChangeSet

#pragma mark - accessors

- (NSMutableArray<VMKSingleChange *> *)history {
    if (_history) {
        return _history;
    }
    _history = [[NSMutableArray alloc] init];
    return _history;
}

#pragma mark - isEqualTo

- (BOOL)isEqualToChangeSet:(VMKChangeSet *)other {
    if (!other) {
        return NO;
    }
    
    return ([self.history isEqual:other.history]);
}

#pragma mark - status

- (NSIndexPath *)changedIndexPathForPreviousIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath) {
        return nil;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    for (VMKSingleChange *singleChange in self.history) {
        switch (singleChange.type) {
            case VMKSingleChangeTypeSectionInserted:
                if (section >= (NSInteger)singleChange.section) {
                    ++section;
                }
                break;
                
            case VMKSingleChangeTypeSectionDeleted:
                if (section == (NSInteger)singleChange.section) {
                    return nil;
                }
                if (section > (NSInteger)singleChange.section) {
                    --section;
                }
                break;
                
            case VMKSingleChangeTypeRowInserted:
                if (section != singleChange.rowIndexPath.section) {
                    break;
                }
                if (row >= singleChange.rowIndexPath.row) {
                    ++row;
                }
                break;
            case VMKSingleChangeTypeRowDeleted:
                if (section != singleChange.rowIndexPath.section) {
                    break;
                }
                if (row == singleChange.rowIndexPath.row) {
                    return nil;
                }
                if (row > singleChange.rowIndexPath.row) {
                    --row;
                }
                break;
                
            case VMKSingleChangeTypeRowMoved:
                if ((singleChange.rowIndexPath.section == section) && (singleChange.rowIndexPath.row == row)) {
                    section = singleChange.movedToRowIndexPath.section;
                    row = singleChange.movedToRowIndexPath.row;
                    break;
                }
                
                // delete row
                if (section == singleChange.rowIndexPath.section) {
                    if (row > singleChange.rowIndexPath.row) {
                        --row;
                    }
                }
                if (section == singleChange.movedToRowIndexPath.section) {
                    if (row >= singleChange.movedToRowIndexPath.row) {
                        ++row;
                    }
                }
                break;
                
            case VMKSingleChangeTypeSectionChanged:
                // fallthrough
            case VMKSingleChangeTypeRowChanged:
                // nothing todo
                break;
        }
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    return newIndexPath;
}

#pragma mark - changes

- (void)insertedSectionAtIndex:(NSUInteger)index {
    [self.history addObject:[[VMKSingleChange alloc] initWithInsertedSection:index]];
}

- (void)deletedSectionAtIndex:(NSUInteger)index {
    [self.history addObject:[[VMKSingleChange alloc] initWithDeletedSection:index]];
}

- (void)changedSectionAtIndex:(NSUInteger)index {
    [self.history addObject:[[VMKSingleChange alloc] initWithChangedSection:index]];
}

- (void)insertedRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    [self.history addObject:[[VMKSingleChange alloc] initWithInsertedRow:indexPath]];
}

- (void)deletedRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    [self.history addObject:[[VMKSingleChange alloc] initWithDeletedRow:indexPath]];
}

- (void)changedRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    [self.history addObject:[[VMKSingleChange alloc] initWithChangedRow:indexPath]];
}

- (void)movedRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (!indexPath || !toIndexPath) {
        return;
    }
    
    if ((indexPath.section == toIndexPath.section) && (indexPath.row == toIndexPath.row)) {
        // nothing to do, this is a move to the same position, it is an update
        [self.history addObject:[[VMKSingleChange alloc] initWithChangedRow:indexPath]];
    } else {
        [self.history addObject:[[VMKSingleChange alloc] initWithMovedRow:indexPath to:toIndexPath]];
    }
}

#pragma mark - modifiy changeset

- (void)applySectionOffset:(NSInteger)sectionOffset rowOffset:(NSInteger)rowOffset {

    for (VMKSingleChange *singleChange in self.history) {
        
        [singleChange applySectionOffset:sectionOffset rowOffset:rowOffset];
    }
}

#pragma mark - clean up

- (void)cleanUp {
    
    NSInteger insertedIndex = 0;
    NSInteger currentIndex = 0;
    NSUInteger section = 0;
    VMKSingleChange *insertedSection;
    
    NSArray *history = [self.history copy];
    for (VMKSingleChange *singleChange in history) {
        switch (singleChange.type) {
            case VMKSingleChangeTypeSectionInserted:
                insertedIndex = currentIndex;
                section = singleChange.section;
                insertedSection = singleChange;
                break;
                
            case VMKSingleChangeTypeSectionDeleted:
                if (currentIndex == insertedIndex + 1) {
                    if (section == singleChange.section) {
                        NSLog(@"**** inserted / deleted section issue detected !!");
                        NSLog(@"Before %@", self);
                        [self.history removeObject:singleChange];
                        insertedSection.type = VMKSingleChangeTypeSectionChanged;
                        NSLog(@"After %@\n******", self);
                    }
                }
                break;
                
                // nothing
            case VMKSingleChangeTypeRowInserted:
            case VMKSingleChangeTypeRowDeleted:
            case VMKSingleChangeTypeRowMoved:
            case VMKSingleChangeTypeSectionChanged:
            case VMKSingleChangeTypeRowChanged:
                break;
        }
        ++currentIndex;
    }
}

#pragma mark - NSObject

- (NSString *)description {
    
    NSString *generalDescription = [super description];
    NSMutableString *description = [[NSMutableString alloc] initWithFormat:@"%@ with History of %ld", generalDescription, (long)self.history.count];
    
    long i = 1;
    for (VMKSingleChange *singleChange in self.history) {
        [description appendFormat:@"\n  %ld. %@", i, [singleChange description]];
        ++i;
    }
    return description;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToChangeSet:object];
}

- (NSUInteger)hash {
    return self.history.hash;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    VMKChangeSet *changetSet = [VMKChangeSet new];
    changetSet.history = [self.history mutableCopy];
    return changetSet;
}

@end
