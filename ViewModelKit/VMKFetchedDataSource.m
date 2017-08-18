//
//  VMKFetchedDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 23.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKFetchedDataSource+Private.h"

@implementation VMKFetchedDataSource

const NSUInteger VMKFetchedDataSourceTitleHeaderSectionMinCounter = 10;
const NSUInteger VMKFetchedDataSourceTitleIndexSectionMinCounter = 5;


#pragma mark - init

- (void)dealloc {
    // the delegate of the NSFetchedResultsController is not weak!
    _fetchedResultsController.delegate = nil;
}

- (instancetype)initWithFetchedResultsController:(nullable NSFetchedResultsController *)fetchedResultsController factory:(nullable id<VMKCellViewModelFactory>)factory {
    
    self = [super init];
    if (self) {
        _factory = factory;
        _titleHeaderSectionMinCounter = VMKFetchedDataSourceTitleHeaderSectionMinCounter;
        _titleIndexSectionMinCounter = VMKFetchedDataSourceTitleIndexSectionMinCounter;
        self.fetchedResultsController = fetchedResultsController;
    }
    return self;
}

#pragma mark - accessors

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != fetchedResultsController) {

        if (_fetchedResultsController) {
            [self.viewModelCache resetCache];
        }
        
        _fetchedResultsController = fetchedResultsController;
        _fetchedResultsController.delegate = self.fetchedUpdater;
    }
}

+ (BOOL)automaticallyNotifiesObserversOfReportChanges {
    return NO;
}

- (void)setReportChanges:(BOOL)reportChanges {
    
    if (_reportChanges != reportChanges) {
        [self willChangeValueForKey:@"isReportChanges"];
        _reportChanges = reportChanges;
        self.fetchedUpdater.reportChangeUpdates = reportChanges;
        [self didChangeValueForKey:@"isReportChanges"];
    }
}

- (VMKViewModelCache *)viewModelCache {
    if (!_viewModelCache) {
        _viewModelCache = [[VMKViewModelCache alloc] init];
    }
    return _viewModelCache;
}

- (VMKFetchedUpdater *)fetchedUpdater {
    if (!_fetchedUpdater) {
        _fetchedUpdater = [[VMKFetchedUpdater alloc] init];
        _fetchedUpdater.delegate = self;
    }
    return _fetchedUpdater;
}

#pragma mark - VMKDataSourceType

- (NSInteger)sections {
    return (NSInteger)self.fetchedResultsController.sections.count;
}

- (NSInteger)rowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger)section];
    return (NSInteger)[sectionInfo numberOfObjects];
}

- (__kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath {

    VMKViewModel<VMKCellType> *vm = [self.viewModelCache viewModelAtIndexPath:indexPath];
    if (vm) {
        return vm;
    }
    return [self insertedViewModelInCacheAtIndexPath:indexPath];
}

#pragma mark - VMKDataSourceType section header / footer

- (nullable NSString *)titleForHeaderInSection:(NSInteger)section {
    if (self.fetchedResultsController.sectionIndexTitles.count > (NSUInteger)section && self.fetchedResultsController.sections.count > self.titleHeaderSectionMinCounter) {
        
        return self.fetchedResultsController.sectionIndexTitles[(NSUInteger)section];
    }
    return nil;
}

#pragma mark - VMKDataSourceType section index

- (nullable NSArray<NSString *> *)sectionIndexTitles {
    if (self.fetchedResultsController.sections.count > self.titleIndexSectionMinCounter) {
        return self.fetchedResultsController.sectionIndexTitles;
    }
    return nil;
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark - cache

- (nullable __kindof VMKViewModel<VMKCellType> *)insertedViewModelInCacheAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!object) {
        return nil;
    }
    
    __kindof VMKViewModel<VMKCellType> *vm = [self.factory cellViewModelForDataSource:self object:object];
    if (vm) {
        [self.viewModelCache setViewModel:vm atIndexPath:indexPath];
    }
    return vm;
}

#pragma mark - VMKFetchedUpdaterDelegate

- (void)fetchedUpdater:(VMKFetchedUpdater *)fetchedUpater didChangeWithChangeSet:(VMKChangeSet *)changeSet {
    
    [changeSet cleanUp];
    if (changeSet.history.count > 0) {
        [self.viewModelCache changeCacheWithChangeSet:changeSet];
        [self.delegate dataSource:self didUpdateChangeSet:changeSet];
    }
}

@end
