//
//  VMKFetchedUpdater.h
//  ViewModelKit
//
//  Created by Andre Trettin on 03.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;
@import CoreData;

@class VMKFetchedUpdater;
@class VMKChangeSet;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKFetchedUpdaterDelegate <NSObject>
- (void)fetchedUpdater:(VMKFetchedUpdater *)fetchedUpdater didChangeWithChangeSet:(VMKChangeSet *)changeSet;
@end

@interface VMKFetchedUpdater : NSObject <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) id<VMKFetchedUpdaterDelegate> delegate;
@property (nonatomic, assign, getter=isReportChangeUpdates) BOOL reportChangeUpdates;
@end

NS_ASSUME_NONNULL_END
