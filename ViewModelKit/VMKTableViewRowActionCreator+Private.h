//
//  VMKTableViewRowActionCreator+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 03/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKTableViewRowActionCreator.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewRowActionCreator ()
@property (nonatomic, strong) id<VMKTableViewRowActionsType> rowActionsType;
@property (nonatomic, strong) UITableView *tableView;

- (void)handleRowAction:(VMKTableViewRowActionViewModel *)rowAction atIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
