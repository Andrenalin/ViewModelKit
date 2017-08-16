//
//  MainCoreDataChanger.m
//  VMKExample
//
//  Created by Andre Trettin on 08/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "MainCoreDataChanger.h"

#import "SomeData+CoreDataClass.h"

@interface MainCoreDataChanger ()
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@end

@implementation MainCoreDataChanger

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext {
    self = [super init];
    if (self) {
        _mainContext = mainContext;
    }
    return self;
}

- (void)start {
    
    [self insertData];
    [self deleteData];
    [self changeData];
    
    NSError *error;
    if (![self.mainContext save:&error]) {
        NSLog(@"error %@", error);
        abort();
    }

    [self performSelector:@selector(start) withObject:nil afterDelay:0.242];
}

- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)insertData {
    
    static NSUInteger counter = 1;
    
    NSUInteger insertCount = [self roleDiceWithSides:13];
    for (NSUInteger i = 0; i < insertCount; ++i) {
        SomeData *someData = [NSEntityDescription insertNewObjectForEntityForName:@"SomeData" inManagedObjectContext:self.mainContext];
        
        someData.title = [NSString stringWithFormat:@"%d - %d", (int)counter, (int)i];
        someData.subtitle = [NSUUID UUID].UUIDString;
    }
    ++counter;
}

- (void)deleteData {
    
    SomeData *someData;
    while ((someData = [self someDataAtAnyPosition]) != nil) {
        [self.mainContext deleteObject:someData];
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
    NSArray *someDatas = [self.mainContext executeFetchRequest:fetchRequest error:&error];
    
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
