//
//  FakeCollectionView.m
//  ViewModelKit
//
//  Created by Andre Trettin on 20/03/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "FakeCollectionView.h"

@implementation FakeCollectionView

- (void)performBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion {

    self.performBatchUpdatesCompletionCalled++;
    self.performBatchUpdatesCompletionUpdateBlockParameter = updates;
    self.performBatchUpdatesCompletionCompletionBlockParameter = completion;
}

- (void)reloadSections:(NSIndexSet *)sections {
    self.reloadSectionsCalled++;
    self.reloadSectionsSectionsParameter = sections;
}

- (void)insertSections:(NSIndexSet *)sections {
    self.insertSectionsCalled++;
    self.insertSectionsSectionsParameter = sections;
}

- (void)deleteSections:(NSIndexSet *)sections {
    self.deleteSectionsCalled++;
    self.deleteSectionsSectionsParameter = sections;
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    self.reloadItemsAtIndexPathCalled++;
    self.reloadItemsAtIndexPathRowsParameter = indexPaths;
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    self.insertItemsAtIndexPathCalled++;
    self.insertItemsAtIndexPathRowsParameter = indexPaths;
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    self.deleteItemsAtIndexPathCalled++;
    self.deleteItemsAtIndexPathRowsParameter = indexPaths;
}

@end
