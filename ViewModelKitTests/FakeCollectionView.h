//
//  FakeCollectionView.h
//  ViewModelKit
//
//  Created by Andre Trettin on 20/03/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import UIKit;

@interface FakeCollectionView : UICollectionView

@property (nonatomic, assign) NSInteger performBatchUpdatesCompletionCalled;
@property (nonatomic, copy) id (^block)(id object);

@property (nonatomic, copy) void (^performBatchUpdatesCompletionUpdateBlockParameter)(void);
@property (nonatomic, copy) void (^performBatchUpdatesCompletionCompletionBlockParameter)(BOOL finished);

@property (nonatomic, assign) NSInteger reloadSectionsCalled;
@property (nonatomic, strong) NSIndexSet *reloadSectionsSectionsParameter;

@property (nonatomic, assign) NSInteger insertSectionsCalled;
@property (nonatomic, strong) NSIndexSet *insertSectionsSectionsParameter;

@property (nonatomic, assign) NSInteger deleteSectionsCalled;
@property (nonatomic, strong) NSIndexSet *deleteSectionsSectionsParameter;

@property (nonatomic, assign) NSInteger reloadItemsAtIndexPathCalled;
@property (nonatomic, strong) NSArray<NSIndexPath *> *reloadItemsAtIndexPathRowsParameter;

@property (nonatomic, assign) NSInteger insertItemsAtIndexPathCalled;
@property (nonatomic, strong) NSArray<NSIndexPath *> *insertItemsAtIndexPathRowsParameter;

@property (nonatomic, assign) NSInteger deleteItemsAtIndexPathCalled;
@property (nonatomic, strong) NSArray<NSIndexPath *> *deleteItemsAtIndexPathRowsParameter;

@end
