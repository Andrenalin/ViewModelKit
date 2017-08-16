//
//  VMKArrayModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKArrayModel+Private.h"

@implementation VMKArrayModel

#pragma mark - init

- (instancetype)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        _array = [array mutableCopy];
    }
    return self;
}

#pragma mark - properties

- (NSArray *)contents {
    return [self.array copy];
}

#pragma mark - NSArray proxy

- (NSUInteger)count {
    return self.array.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self.array objectAtIndex:index];
}

- (NSUInteger)indexOfObject:(id)object {
    return [self.array indexOfObject:object];
}

#pragma mark - NSMutableArray proxy

- (void)addObject:(id)object {
    [self insertObject:object atIndex:self.array.count];
}

- (void)removeObject:(id)object {

    NSUInteger index = [self.array indexOfObject:object];
    
    if (index == NSNotFound) {
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {

    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:NSStringFromSelector(@selector(array))];
    
    [self.array insertObject:object atIndex:index];
    
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:NSStringFromSelector(@selector(array))];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:NSStringFromSelector(@selector(array))];
    
    [self.array removeObjectAtIndex:index];
    
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:NSStringFromSelector(@selector(array))];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexSet forKey:NSStringFromSelector(@selector(array))];
    
    [self.array replaceObjectAtIndex:index withObject:anObject];
    
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexSet forKey:NSStringFromSelector(@selector(array))];
}

@end
