//
//  FakeTableView.m
//  ViewModelKit
//
//  Created by Andre Trettin on 15/03/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "FakeTableView.h"

@implementation FakeTableView

- (void)beginUpdates {
    self.beginUpdatesCalled++;
}

- (void)endUpdates {
    self.endUpdatesCalled++;
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    self.reloadSectionsWithRowAnimationCalled++;
    self.reloadSectionsWithRowAnimationSectionsParameter = sections;
    self.reloadSectionsWithRowAnimationTableViewRowAnimationParameter = animation;
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    self.insertSectionsWithRowAnimationCalled++;
    self.insertSectionsWithRowAnimationSectionsParameter = sections;
    self.insertSectionsWithRowAnimationTableViewRowAnimationParameter = animation;
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    self.deleteSectionsWithRowAnimationCalled++;
    self.deleteSectionsWithRowAnimationSectionsParameter = sections;
    self.deleteSectionsWithRowAnimationTableViewRowAnimationParameter = animation;
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    self.reloadRowsAtIndexPathsWithRowAnimationCalled++;
    self.reloadRowsAtIndexPathsWithRowAnimationIndexPathsParameter = indexPaths;
    self.reloadRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter = animation;
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    self.insertRowsAtIndexPathsWithRowAnimationCalled++;
    self.insertRowsAtIndexPathsWithRowAnimationIndexPathsParameter = indexPaths;
    self.insertRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter = animation;
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    self.deleteRowsAtIndexPathsWithRowAnimationCalled++;
    self.deleteRowsAtIndexPathsWithRowAnimationIndexPathsParameter = indexPaths;
    self.deleteRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter = animation;
}

- (NSIndexPath *)indexPathForSelectedRow {
    self.indexPathForSelectedRowCalled++;
    return self.indexPathForSelectedRowReturn;
}

- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    self.selectRowAtIndexPathAnimatedSrcollPositionCalled++;
    self.selectRowAtIndexPathAnimatedSrcollPositionIndexPathParameter = indexPath;
    self.selectRowAtIndexPathAnimatedSrcollPositionAnimatedParameter = animated;
    self.selectRowAtIndexPathAnimatedSrcollPositionTableViewScrollPositionParameter = scrollPosition;
}

@end
