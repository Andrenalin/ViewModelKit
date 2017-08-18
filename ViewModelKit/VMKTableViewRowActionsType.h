//
//  VMKTableViewRowActionsType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 22/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKTableViewRowActionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKTableViewRowActionsType <NSObject>
@property (nonatomic, copy, readonly, nullable) NSArray<VMKTableViewRowActionViewModel *> *rowActions;
@end

NS_ASSUME_NONNULL_END
