//
//  VMKCellType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 13.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKTableViewRowActionsType.h"

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKCellType <NSObject>
- (nullable __kindof VMKViewModel *)viewModel;

@optional
// this is only needed for System UITableViewCells
- (nullable NSString *)title;
- (nullable NSString *)subtitle;
- (nullable UIImage *)image;

// this can be implemented by custom and UITableViewCells
- (BOOL)canEdit;
- (BOOL)canDelete;
- (BOOL)canInsert;
- (BOOL)canMove;

- (void)deleteData;
- (void)moveToIndexPath:(NSIndexPath *)destinationIndexPath;

// row actions
- (nullable id<VMKTableViewRowActionsType>)rowActions;
@end

NS_ASSUME_NONNULL_END
