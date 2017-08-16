//
//  VMKFetchedDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 23.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import CoreData;

#import "VMKDataSource.h"
#import "VMKViewModelCache.h"
#import "VMKCellViewModelFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKFetchedDataSource : VMKDataSource
@property (nonatomic, strong, nullable, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<VMKCellViewModelFactory> factory;
@property (nonatomic, strong, readonly) VMKViewModelCache *viewModelCache;

#pragma mark - configure

@property (nonatomic, assign, getter=isReportChanges) BOOL reportChanges;
@property (nonatomic, assign) NSUInteger titleHeaderSectionMinCounter;
@property (nonatomic, assign) NSUInteger titleIndexSectionMinCounter;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFetchedResultsController:(nullable NSFetchedResultsController *)fetchedResultsController factory:(nullable id<VMKCellViewModelFactory>)factory NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
