//
//  VMKTableViewRowActionCreator.h
//  ViewModelKit
//
//  Created by Andre Trettin on 22/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKTableViewRowActionsType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewRowActionCreator : NSObject
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTableView:(UITableView *)tableView rowActionsType:(id<VMKTableViewRowActionsType>)rowActionsType NS_DESIGNATED_INITIALIZER;

- (nullable NSArray<UITableViewRowAction *> *)tableViewRowActions;
@end

NS_ASSUME_NONNULL_END
