//
//  AppDelegate.m
//  CoreDataThreading
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import ViewModelKit;

#import "AppDelegate.h"
#import "TableViewModel.h"

@interface AppDelegate ()
@property (strong, nonatomic, readwrite) NSManagedObjectContext *mainContext;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *syncContext;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIViewController *rootVC = self.window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navC = (UINavigationController *)rootVC;
        rootVC = navC.topViewController;
    }
    
    if ([rootVC conformsToProtocol:@protocol(VMKViewModelControllerType)]) {
        UIViewController<VMKViewModelControllerType> *vmvc = (UIViewController<VMKViewModelControllerType> *)rootVC;
        
        TableViewModel *viewModel = [[TableViewModel alloc] initWithMainContext:self.mainContext syncContext:self.syncContext];
        vmvc.viewModel = viewModel;
    }
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "de.andretrettin.CoreViewModel" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSURL *modelURL = [bundle URLForResource:@"CoreDataThreading" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataThreading.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.mainContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - mainContext

- (NSManagedObjectContext *)mainContext {
    if (_mainContext) {
        return _mainContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.persistentStoreCoordinator = coordinator;
    _mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    [self addDidSaveNotificationForMainContext];
    return _mainContext;
}

- (void)addDidSaveNotificationForMainContext {
    if (self.mainContext) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:self.mainContext];
    }
}

- (void)removeDidSaveNotificationForMainContext {
    if (self.mainContext) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:self.mainContext];
    }
}

- (void)mainDidSaveNotification:(NSNotification *)note {
    __weak __typeof(self) weakSelf = self;
    [self.syncContext performBlock:^{
        __typeof(self) strongSelf = weakSelf;
        
        NSSet *updated = [note.userInfo objectForKey:NSUpdatedObjectsKey];
        [strongSelf forceUpdatedObjectInSet:updated inContext:self.syncContext];
        
        [strongSelf.syncContext mergeChangesFromContextDidSaveNotification:note];
    }];
}

#pragma mark - syncContext

- (NSManagedObjectContext *)syncContext {
    if (_syncContext) {
        return _syncContext;
    }
    
    _syncContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_syncContext performBlockAndWait:^{
        _syncContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }];
    _syncContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    [self addDidSaveNotificationForSyncContext];
    return _syncContext;
}

- (void)addDidSaveNotificationForSyncContext {
    if (self.syncContext) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:self.syncContext];
    }
}

- (void)removeDidSaveNotificationForSyncContext {
    if (self.syncContext) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:self.syncContext];
    }
}

- (void)syncDidSaveNotification:(NSNotification *)note {
    __weak __typeof(self) weakSelf = self;
    [self.mainContext performBlock:^{
        __typeof(self) strongSelf = weakSelf;
        
        NSSet *updated = [note.userInfo objectForKey:NSUpdatedObjectsKey];
        [strongSelf forceUpdatedObjectInSet:updated inContext:self.mainContext];
        
        [strongSelf.mainContext mergeChangesFromContextDidSaveNotification:note];
    }];
}

#pragma mark - merge changes helper

- (void)forceUpdatedObjectInSet:(NSSet *)updatedObjects inContext:(NSManagedObjectContext *)context {
    // see http://mikeabdullah.net/merging-saved-changes-betwe.html
    // and in our git an example crash
    // see https://github.com/orderbird/pos/issues/5082
    //
    // NSManagedObjectContext's merge routine ignores updated objects which aren't
    // currently faulted in. To force it to notify interested clients that such
    // objects have been refreshed (e.g. NSFetchedResultsController) we need to
    // force them to be faulted in ahead of the merge
    
    for (NSManagedObject *object in updatedObjects) {
        // The objects can't be a fault. -existingObjectWithID:error: is a
        // nice easy way to achieve that in a single swoop.
        [context existingObjectWithID:object.objectID error:NULL];
    }
}

@end
