//
//  VMKChangeWatcher.m
//  ViewModelKit
//
//  Created by Andre Trettin on 23.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import CoreData;

#import "VMKChangeWatcher+Private.h"

@implementation VMKChangeWatcher

#pragma mark - init

- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    self = [super init];
    if (self) {
        _persistentStoreCoordinator = persistentStoreCoordinator;
    }
    
    return self;
}

#pragma mark - properties

- (NSMutableSet<__kindof NSManagedObject *> *)objectsToWatch {
    if (_objectsToWatch) {
        return _objectsToWatch;
    }
    
    _objectsToWatch = [[NSMutableSet alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    [self.observerNotificationManager addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil usingBlock:^(NSNotification * _Nonnull notification) {
        
        __typeof(self) strongSelf = weakSelf;
        [strongSelf handleObjectDidChangeNotification:notification];
    }];
    
    return _objectsToWatch;
}

- (VMKObserverNotificationManager *)observerNotificationManager {
    if (_observerNotificationManager) {
        return _observerNotificationManager;
    }
    _observerNotificationManager = [[VMKObserverNotificationManager alloc] init];
    return _observerNotificationManager;
}

#pragma mark - public interface

- (void)addObjectToWatch:(__kindof NSManagedObject *)object {
    [self.objectsToWatch addObject:object];
}

- (void)addObjectsToWatch:(NSArray<__kindof NSManagedObject *> *)objects {
    [self.objectsToWatch addObjectsFromArray:objects];
}

#pragma mark - Notification Handling

- (void)handleObjectDidChangeNotification:(NSNotification *)notification {
    if ([notification.object persistentStoreCoordinator] != self.persistentStoreCoordinator) {
        return;
    }
    
    NSSet<__kindof NSManagedObject *> *changed = [notification.userInfo objectForKey:NSUpdatedObjectsKey];
    if (![self.objectsToWatch intersectsSet:changed]) {
        return;
    }

    NSMutableSet<__kindof NSManagedObject *> *objectsChanged = [NSMutableSet set];
    for (NSManagedObject *object in changed) {
        if ([self.objectsToWatch containsObject:object]) {
            [objectsChanged addObject:object];
        }
    }
    
    [self.delegate changeWatcher:self changedObjects:objectsChanged];
}

@end
