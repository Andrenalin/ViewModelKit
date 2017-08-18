//
//  VMKChangeWatcher.h
//  ViewModelKit
//
//  Created by Andre Trettin on 23.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class VMKChangeWatcher;

@protocol VMKChangeWatcherDelegate <NSObject>
- (void)changeWatcher:(VMKChangeWatcher *)changeWatcher changedObjects:(NSSet *)objects;
@end

@interface VMKChangeWatcher : NSObject
@property (nonatomic, weak) id<VMKChangeWatcherDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator NS_DESIGNATED_INITIALIZER;

- (void)addObjectToWatch:(__kindof NSManagedObject * _Nonnull)object;
- (void)addObjectsToWatch:(NSArray<__kindof NSManagedObject *> * _Nonnull)objects;
@end

NS_ASSUME_NONNULL_END
