//
//  FakeTableView.h
//  ViewModelKit
//
//  Created by Andre Trettin on 15/03/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import UIKit;

@interface FakeTableView : UITableView
@property (nonatomic, assign) NSInteger beginUpdatesCalled;
@property (nonatomic, assign) NSInteger endUpdatesCalled;

@property (nonatomic, assign) NSInteger reloadSectionsWithRowAnimationCalled;
@property (nonatomic, strong) NSIndexSet *reloadSectionsWithRowAnimationSectionsParameter;
@property (nonatomic, assign) UITableViewRowAnimation reloadSectionsWithRowAnimationTableViewRowAnimationParameter;

@property (nonatomic, assign) NSInteger insertSectionsWithRowAnimationCalled;
@property (nonatomic, strong) NSIndexSet *insertSectionsWithRowAnimationSectionsParameter;
@property (nonatomic, assign) UITableViewRowAnimation insertSectionsWithRowAnimationTableViewRowAnimationParameter;

@property (nonatomic, assign) NSInteger deleteSectionsWithRowAnimationCalled;
@property (nonatomic, strong) NSIndexSet *deleteSectionsWithRowAnimationSectionsParameter;
@property (nonatomic, assign) UITableViewRowAnimation deleteSectionsWithRowAnimationTableViewRowAnimationParameter;

@property (nonatomic, assign) NSInteger reloadRowsAtIndexPathsWithRowAnimationCalled;
@property (nonatomic, strong) NSArray<NSIndexPath *> *reloadRowsAtIndexPathsWithRowAnimationIndexPathsParameter;
@property (nonatomic, assign) UITableViewRowAnimation reloadRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter;

@property (nonatomic, assign) NSInteger insertRowsAtIndexPathsWithRowAnimationCalled;
@property (nonatomic, strong) NSArray<NSIndexPath *> *insertRowsAtIndexPathsWithRowAnimationIndexPathsParameter;
@property (nonatomic, assign) UITableViewRowAnimation insertRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter;

@property (nonatomic, assign) NSInteger deleteRowsAtIndexPathsWithRowAnimationCalled;
@property (nonatomic, strong) NSArray<NSIndexPath *> *deleteRowsAtIndexPathsWithRowAnimationIndexPathsParameter;
@property (nonatomic, assign) UITableViewRowAnimation deleteRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter;

@property (nonatomic, assign) NSInteger indexPathForSelectedRowCalled;
@property (nonatomic, strong) NSIndexPath *indexPathForSelectedRowReturn;

@property (nonatomic, assign) NSInteger selectRowAtIndexPathAnimatedSrcollPositionCalled;
@property (nonatomic, assign) NSInteger selectRowAtIndexPathAnimatedSrcollPositionTableViewScrollPositionParameter;

@property (nonatomic, strong) NSIndexPath *selectRowAtIndexPathAnimatedSrcollPositionIndexPathParameter;
@property (nonatomic, assign) BOOL selectRowAtIndexPathAnimatedSrcollPositionAnimatedParameter;

@end
