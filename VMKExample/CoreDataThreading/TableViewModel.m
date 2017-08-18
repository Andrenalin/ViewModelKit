//
//  TableViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "TableViewModel.h"
#import "SomeData+CoreDataClass.h"
#import "CellViewModel.h"

#import "SyncController.h"
#import "MainCoreDataChanger.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewModel () <VMKCellViewModelFactory>
@property (nonatomic, assign, readwrite) BOOL running;

@property (nonatomic, strong, readwrite) VMKDataSource *dataSource;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *syncContext;

@property (nonatomic, strong, nullable) SyncController *syncController;
@property (nonatomic, strong, nullable) MainCoreDataChanger *mainCoreDataChanger;
@end

NS_ASSUME_NONNULL_END


@implementation TableViewModel

+ (NSString *)runningKeyPath {
    return @"running";
}

#pragma mark - init

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext syncContext:(NSManagedObjectContext *)syncContext {
    self = [super init];
    if (self) {
        _mainContext = mainContext;
        _syncContext = syncContext;
    }
    return self;
}

- (SyncController *)syncController {
    if (_syncController) {
        return _syncController;
    }
    _syncController = [[SyncController alloc] initWithSyncContext:self.syncContext];
    return _syncController;
}

- (MainCoreDataChanger *)mainCoreDataChanger {
    if (_mainCoreDataChanger) {
        return _mainCoreDataChanger;
    }
    _mainCoreDataChanger = [[MainCoreDataChanger alloc] initWithMainContext:self.mainContext];
    return _mainCoreDataChanger;
}

#pragma mark - user actions

- (void)start {
    if (!self.running) {
        self.running = YES;
        
        [self.syncController start];
        [self.mainCoreDataChanger start];
    }
}

- (void)stop {
    if (self.running) {
        [self.syncController stop];
        [self.mainCoreDataChanger stop];
        
        self.running = NO;
        self.syncController = nil;
        self.mainCoreDataChanger = nil;
    }
}

#pragma mark - VMKTableViewModelType

- (VMKDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[VMKFetchedDataSource alloc] initWithFetchedResultsController:[self fetchedResultsController] factory:self];
    }
    return _dataSource;
}

- (VMKViewModel<VMKCellType> *)cellViewModelForDataSource:(VMKDataSource *)dataSource object:(id)object {
    
    CellViewModel *cvm = [[CellViewModel alloc] init];
    cvm.model = object;
    
    return cvm;
}

- (NSFetchedResultsController *)fetchedResultsController {
    NSFetchRequest<SomeData *> *fr = [SomeData fetchRequest];
    
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:self.mainContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error;
    if (![frc performFetch:&error]) {
        NSLog(@"Error %@", error);
        abort();
    }
    return frc;
}

@end
