//
//  VMKViewModelCache.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewModelCache.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"

// @TODO: use NSCache and  
@interface VMKViewModelCache ()
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary*> *sections;
@end

@implementation VMKViewModelCache

#pragma mark - accessors

- (NSMutableDictionary *)sections {
    if (!_sections) {
        _sections = [[NSMutableDictionary alloc] init];
    }
    return _sections;
}

#pragma mark - public interface

- (nullable __kindof VMKViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *rows = [self rowsForIndexPath:indexPath];
    return [self viewModelRows:rows atIndex:indexPath.row];
}

- (void)setViewModel:(__kindof VMKViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *rows = [self rowsForIndexPath:indexPath];
    if (!rows) {
        rows = [NSMutableDictionary new];
        [self.sections setObject:rows forKey:[self keyForInteger:indexPath.section]];
    }
    
    [rows setObject:viewModel forKey:[self keyForInteger:indexPath.row]];
}

- (void)changeCacheWithChangeSet:(VMKChangeSet *)changeSet {
    
    for (VMKSingleChange *singleChange in changeSet.history) {
        switch (singleChange.type) {
            case VMKSingleChangeTypeSectionChanged:
                break;
            case VMKSingleChangeTypeSectionInserted:
                [self changeSectionIndex:(NSInteger)singleChange.section byOffset:1];
                break;
            case VMKSingleChangeTypeSectionDeleted:
                [self.sections removeObjectForKey:[self keyForInteger:(NSInteger)singleChange.section]];
                [self changeSectionIndex:(NSInteger)(singleChange.section + 1) byOffset:-1];
                break;
                
            case VMKSingleChangeTypeRowChanged: {
                NSMutableDictionary *rows = [self rowsForIndexPath:singleChange.rowIndexPath];
                [rows removeObjectForKey:[self keyForInteger:singleChange.rowIndexPath.row]];
            }
                break;
            case VMKSingleChangeTypeRowInserted: {
                NSMutableDictionary *rows = [self rowsForIndexPath:singleChange.rowIndexPath];
                [self changeRows:rows index:singleChange.rowIndexPath.row byOffset:1];
            }
                break;
            case VMKSingleChangeTypeRowDeleted: {
                NSMutableDictionary *rows = [self rowsForIndexPath:singleChange.rowIndexPath];
                [rows removeObjectForKey:[self keyForInteger:singleChange.rowIndexPath.row]];
                [self changeRows:rows index:(singleChange.rowIndexPath.row + 1) byOffset:-1];
            }
                break;
            case VMKSingleChangeTypeRowMoved: {
                
                NSIndexPath *fromIndexPath = singleChange.rowIndexPath;
                NSIndexPath *toIndexPath = singleChange.movedToRowIndexPath;
                if (!fromIndexPath || !toIndexPath) {
                    break;
                }
                
                VMKViewModel *vm = [self viewModelAtIndexPath:fromIndexPath];
                if (vm) {
                    NSMutableDictionary *rows = [self rowsForIndexPath:fromIndexPath];
                    [rows removeObjectForKey:[self keyForInteger:fromIndexPath.row]];
                    [self changeRows:rows index:(fromIndexPath.row + 1) byOffset:-1];
                    
                    rows = [self rowsForIndexPath:toIndexPath];
                    [self changeRows:rows index:toIndexPath.row byOffset:1];
                    [self setViewModel:vm atIndexPath:toIndexPath];
                }
            }
                break;
        }
    }
}

- (void)resetCache {
    self.sections = nil;
}

#pragma mark - helpers

- (void)changeSectionIndex:(NSInteger)effectedIndex byOffset:(NSInteger)offset {
    
    NSArray *sectionIndexKeys = [self.sections allKeys];
    NSMutableDictionary *insertedSections = [[NSMutableDictionary alloc] initWithCapacity:(sectionIndexKeys.count / 2 + 1)];
    for (NSString *indexKey in sectionIndexKeys) {
        NSInteger index = [self integerForKey:indexKey];
        if (index >= effectedIndex) {
            NSMutableDictionary *rows = [self rowsForSectionIndex:index];
            [self.sections removeObjectForKey:[self keyForInteger:index]];
            [insertedSections setObject:rows forKey:[self keyForInteger:index + offset]];
        }
    }
    [self.sections addEntriesFromDictionary:insertedSections];
}

- (void)changeRows:(NSMutableDictionary *)rows index:(NSInteger)effectedIndex
          byOffset:(NSInteger)offset {
    
    NSArray *rowIndexKeys = [rows allKeys];
    NSMutableDictionary *insertedRows = [[NSMutableDictionary alloc] initWithCapacity:(rowIndexKeys.count / 2 + 1)];
    for (NSString *indexKey in rowIndexKeys) {
        NSInteger index = [self integerForKey:indexKey];
        if (index >= effectedIndex) {
            VMKViewModel *vm = [self viewModelRows:rows atIndex:index];
            [rows removeObjectForKey:[self keyForInteger:index]];
            [insertedRows setObject:vm forKey:[self keyForInteger:index + offset]];
        }
    }
    [rows addEntriesFromDictionary:insertedRows];
}

- (NSInteger)integerForKey:(NSString *)key {
    return [key integerValue];
}

- (NSString *)keyForInteger:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld", (unsigned long)number];
}

- (NSMutableDictionary<NSString *, VMKViewModel *> *)rowsForIndexPath:(NSIndexPath *)indexPath {
    return [self.sections objectForKey:[self keyForInteger:indexPath.section]];
}

- (NSMutableDictionary<NSString *, VMKViewModel *> *)rowsForSectionIndex:(NSInteger)index {
    return [self.sections objectForKey:[self keyForInteger:index]];
}

- (VMKViewModel *)viewModelRows:(NSMutableDictionary<NSString *, VMKViewModel *> *)rows
                        atIndex:(NSInteger)index {
    return [rows objectForKey:[self keyForInteger:index]];
}

#pragma mark - NSObject

- (NSString *)description {
    NSString *superDescription = [super description];
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@ has %ld sections",
                                    superDescription, (unsigned long)self.sections.count];
    [self.sections enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                       id  _Nonnull obj,
                                                       BOOL * _Nonnull stop) {
        [description appendFormat:@"Key: %@ --> %@", key, obj];
    }];
    return description;
}

@end
