//
//  VMKDeleteWatcher+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 02/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKDeleteWatcher.h"
#import "VMKObserverNotificationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKDeleteWatcher()
@property (nonatomic, weak) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableSet<__kindof NSManagedObject *> *objectsToWatch;
@property (nonatomic, strong) VMKObserverNotificationManager *observerNotificationManager;

- (void)handleObjectDidChangeNotification:(NSNotification *)notification;
@end

NS_ASSUME_NONNULL_END
