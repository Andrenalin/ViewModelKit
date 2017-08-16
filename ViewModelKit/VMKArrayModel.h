//
//  VMKArrayModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface VMKArrayModel<__covariant ObjectType> : NSObject
@property (nonatomic, copy, readonly) NSArray<ObjectType> *contents;
@property (nonatomic, assign, readonly) NSUInteger count;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithArray:(NSArray<ObjectType> *)array NS_DESIGNATED_INITIALIZER;

- (ObjectType)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(ObjectType)object;

- (void)addObject:(ObjectType)object;
- (void)removeObject:(ObjectType)object;

- (void)insertObject:(ObjectType)object atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;
@end

NS_ASSUME_NONNULL_END
