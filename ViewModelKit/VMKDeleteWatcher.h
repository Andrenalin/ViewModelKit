//
//  VMKDeleteWatcher.h
//  ViewModelKit
//
//  Created by Andre Trettin on 23.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class VMKDeleteWatcher;

@protocol VMKDeleteWatcherDelegate <NSObject>
- (void)deleteWatcher:(VMKDeleteWatcher *)deleteWatcher deletedObjects:(NSSet *)objects;
@end

@interface VMKDeleteWatcher : NSObject
@property (nonatomic, weak) id<VMKDeleteWatcherDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator NS_DESIGNATED_INITIALIZER;

- (void)addObjectToWatch:(__kindof NSManagedObject *)object;
- (void)addObjectsToWatch:(NSArray<__kindof NSManagedObject *> *)objects;
@end

NS_ASSUME_NONNULL_END
