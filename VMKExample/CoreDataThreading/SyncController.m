//
//  SyncController.m
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "SyncController.h"

#import "SomeData+CoreDataClass.h"

@interface SyncController ()
@property (nonatomic, strong, nonnull) NSOperationQueue *syncQueue;
@property (nonatomic, strong) NSManagedObjectContext *syncContext;
@end

@implementation SyncController

- (instancetype)initWithSyncContext:(NSManagedObjectContext *)syncContext {
    self = [super init];
    if (self) {
        _syncContext = syncContext;
    }
    return self;
}

- (NSOperationQueue *)syncQueue {
    if (_syncQueue) {
        return _syncQueue;
    }
    
    _syncQueue = [[NSOperationQueue alloc] init];
    _syncQueue.name = @"de.andretrettin.vmk.syncQueue";
    _syncQueue.maxConcurrentOperationCount = 1;
    _syncQueue.qualityOfService = NSQualityOfServiceUtility;
    return _syncQueue;
}

- (void)start {
    
    [self.syncQueue addOperationWithBlock:^{
        
        [self.syncContext performBlockAndWait:^{
            [self insertData];
            [self deleteData];
            [self changeData];
            
            NSError *error;
            if (![self.syncContext save:&error]) {
                NSLog(@"error %@", error);
                abort();
            }
        }];
        
    }];
    
    [self performSelector:@selector(start) withObject:nil afterDelay:0.111];
}

- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)insertData {
    
    static NSUInteger counter = 1;
    
    NSUInteger insertCount = [self roleDiceWithSides:13];
    for (NSUInteger i = 0; i < insertCount; ++i) {
        SomeData *someData = [NSEntityDescription insertNewObjectForEntityForName:@"SomeData" inManagedObjectContext:self.syncContext];
        
        someData.title = [NSString stringWithFormat:@"%d - %d", (int)counter, (int)i];
        someData.subtitle = [NSUUID UUID].UUIDString;
    }
    ++counter;
}

- (void)deleteData {
    
    SomeData *someData;
    while ((someData = [self someDataAtAnyPosition]) != nil) {
        [self.syncContext deleteObject:someData];
    }
}

- (void)changeData {
    
    NSUInteger changeCount = [self roleDiceWithSides:7];
    for (NSUInteger i = 0; i < changeCount; ++i) {
        SomeData *someData = [self someDataAtAnyPosition];
        someData.subtitle = [NSUUID UUID].UUIDString;
    }
}

#pragma mark - random

- (SomeData *)someDataAtAnyPosition {
    NSFetchRequest<SomeData *> *fetchRequest = [SomeData fetchRequest];
    fetchRequest.includesSubentities = NO;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES]];
    NSError *error;
    NSArray *someDatas = [self.syncContext executeFetchRequest:fetchRequest error:&error];
    
    if (someDatas.count > 25) {
        NSUInteger lost = [self roleDiceWithSides:someDatas.count] - 1;
        return someDatas[lost];
    }
    return nil;
}

- (NSUInteger)roleDiceWithSides:(NSUInteger)sides {
    NSUInteger value = 0;
    if (sides > 0) {
        value = (NSUInteger)arc4random_uniform((u_int32_t)sides) + 1;
    }
    return value;
}

@end
