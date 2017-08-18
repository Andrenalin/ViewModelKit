//
//  VMKFetchedUpdater.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKFetchedUpdater+Private.h"

@implementation VMKFetchedUpdater

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    self.changeSet = [[VMKChangeSet alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.changeSet insertedSectionAtIndex:sectionIndex];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.changeSet deletedSectionAtIndex:sectionIndex];
            break;
            
        case NSFetchedResultsChangeMove:
            // did not exists for sections.
            break;
            
        case NSFetchedResultsChangeUpdate:
            // usually nothing to do - KVO binding will update it
            // but some datasource might need also the change update
            if (self.reportChangeUpdates) {
                [self.changeSet changedSectionAtIndex:sectionIndex];
            }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.changeSet insertedRowAtIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.changeSet deletedRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
            // usually nothing to do - KVO binding will update it
            // but some datasource might need also the change update
            if (self.reportChangeUpdates) {
                [self.changeSet changedRowAtIndexPath:indexPath];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [self.changeSet movedRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    if (self.changeSet) {
        [self.delegate fetchedUpdater:self didChangeWithChangeSet:(VMKChangeSet *)self.changeSet];
    }
}

@end
