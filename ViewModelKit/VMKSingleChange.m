//
//  VMKSingleChange.m
//  ViewModelKit
//
//  Created by Andre Trettin on 13/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKSingleChange+Private.h"

@implementation VMKSingleChange

#pragma mark - init sections

- (instancetype)initWithChangedSection:(NSUInteger)section {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeSectionChanged;
        _section = section;
    }
    return self;
}

- (instancetype)initWithInsertedSection:(NSUInteger)section {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeSectionInserted;
        _section = section;
    }
    return self;
}

- (instancetype)initWithDeletedSection:(NSUInteger)section {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeSectionDeleted;
        _section = section;
    }
    return self;
}

#pragma mark - init rows 

- (instancetype)initWithChangedRow:(NSIndexPath *)rowIndexPath {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeRowChanged;
        _rowIndexPath = rowIndexPath;
    }
    return self;
}

- (instancetype)initWithInsertedRow:(NSIndexPath *)rowIndexPath {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeRowInserted;
        _rowIndexPath = rowIndexPath;
    }
    return self;
}

- (instancetype)initWithDeletedRow:(NSIndexPath *)rowIndexPath {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeRowDeleted;
        _rowIndexPath = rowIndexPath;
    }
    return self;
}

- (instancetype)initWithMovedRow:(NSIndexPath *)rowIndexPath to:(NSIndexPath *)moveToRowIndexPath {
    self = [super init];
    if (self) {
        _type = VMKSingleChangeTypeRowMoved;
        _rowIndexPath = rowIndexPath;
        _movedToRowIndexPath = moveToRowIndexPath;
    }
    return self;
}

#pragma mark - isEqualToSingleChange

- (BOOL)isEqualToSingleChange:(VMKSingleChange *)other {
    return (self.type == other.type) &&
        (self.section == other.section) &&
        (self.rowIndexPath == other.rowIndexPath) &&
        (self.movedToRowIndexPath == other.movedToRowIndexPath);
}

#pragma mark - convience property

- (NSIndexSet *)sectionSet {
    return [[NSIndexSet alloc] initWithIndex:self.section];
}

- (NSArray<NSIndexPath *> *)rows {
    if (self.rowIndexPath) {
        return @[ (NSIndexPath *)self.rowIndexPath ];
    }
    return @[];
}

- (NSArray<NSIndexPath *> *)movedToRows {
    if (self.movedToRowIndexPath) {
        return @[ (NSIndexPath *)self.movedToRowIndexPath ];
    }
    return @[];
}

#pragma mark - offsets

- (void)applySectionOffset:(NSInteger)sectionOffset rowOffset:(NSInteger)rowOffset {
    
    switch (self.type) {
        case VMKSingleChangeTypeSectionChanged:
        case VMKSingleChangeTypeSectionInserted:
        case VMKSingleChangeTypeSectionDeleted: {
            NSInteger result = (NSInteger)self.section + sectionOffset;
            NSAssert(result >= 0, @"section should be positive, section is %ld", (long)result);
            self.section = (NSUInteger)result;
        }
            break;
            
        case VMKSingleChangeTypeRowMoved: {
            NSInteger section = self.movedToRowIndexPath.section + sectionOffset;
            NSInteger row = self.movedToRowIndexPath.row + rowOffset;
            
            NSAssert(section >= 0 && row >= 0, @"The section %ld and row %ld should be positive", (long)section, (long)row);

            self.movedToRowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
            // fallthrough
        case VMKSingleChangeTypeRowChanged:
        case VMKSingleChangeTypeRowDeleted:
        case VMKSingleChangeTypeRowInserted: {
            NSInteger section = self.rowIndexPath.section + sectionOffset;
            NSInteger row = self.rowIndexPath.row + rowOffset;
            
            NSAssert(section >= 0 && row >= 0, @"The section %ld and row %ld should be positive", (long)section, (long)row);
            
            self.rowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
            break;
    }
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToSingleChange:object];
}

- (NSUInteger)hash {
    return (self.type << 24) ^ (self.section << 16) ^ self.rowIndexPath.hash ^ self.movedToRowIndexPath.hash;
}

- (NSString *)description {
    NSString *generalDescription = [super description];
    NSString *description = [[NSString alloc] initWithFormat:@"%@ - %@:%@", generalDescription, [self typeDescription], [self valueDescription]];
    return description;
}

- (NSString *)typeDescription {
    
    switch (self.type) {
            
        case VMKSingleChangeTypeSectionChanged:
            return @"Changed Section";
        case VMKSingleChangeTypeSectionInserted:
            return @"Inserted Section";
        case VMKSingleChangeTypeSectionDeleted:
            return @"Deleted Section";
        case VMKSingleChangeTypeRowChanged:
            return @"Changed Row";
        case VMKSingleChangeTypeRowInserted:
            return @"Inserted Row";
        case VMKSingleChangeTypeRowDeleted:
            return @"Deleted Row";
        case VMKSingleChangeTypeRowMoved:
            return @"Moved Row";
    }
    return @"Unknown Type";
}

- (NSString *)valueDescription {
    
    switch (self.type) {
            
        case VMKSingleChangeTypeSectionChanged:
        case VMKSingleChangeTypeSectionInserted:
        case VMKSingleChangeTypeSectionDeleted:
            return [[NSString alloc] initWithFormat:@"%ld", (long)self.section];
            
        case VMKSingleChangeTypeRowChanged:
        case VMKSingleChangeTypeRowInserted:
        case VMKSingleChangeTypeRowDeleted:
            return [[NSString alloc] initWithFormat:@"%@", [self descriptionForIndexPath:self.rowIndexPath]];

        case VMKSingleChangeTypeRowMoved:
            return [[NSString alloc] initWithFormat:@"%@ to:%@", [self descriptionForIndexPath:self.rowIndexPath], [self descriptionForIndexPath:self.movedToRowIndexPath]];
    }
    return @"Unknown Type";
}

- (NSString *)descriptionForIndexPath:(NSIndexPath *)indexPath {
    return [[NSString alloc] initWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
}

@end
