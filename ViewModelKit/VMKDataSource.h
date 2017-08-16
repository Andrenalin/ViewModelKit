//
//  VMKDataSource.h
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKDataSourceType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKDataSource : NSObject <VMKDataSourceType, VMKDataSourceDelegate>
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, weak) id<VMKDataSourceDelegate> delegate;

// Inserting - Deleting Rows
- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAtIndexPath:(NSIndexPath *)indexPath;
- (void)insertAtIndexPath:(NSIndexPath *)indexPath;

// Reordering
- (BOOL)canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
@end

NS_ASSUME_NONNULL_END
