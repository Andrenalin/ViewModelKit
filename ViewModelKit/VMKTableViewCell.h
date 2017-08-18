//
//  VMKTableViewCell.h
//  ViewModelKit
//
//  Created by Andre Trettin on 09/01/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewCellType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewCell<__covariant CellViewModel:__kindof VMKViewModel<VMKCellType> *> : UITableViewCell <VMKViewCellType>

@property (class, nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, strong, nullable) CellViewModel viewModel;

- (VMKBindingDictionary *)viewModelBindings;
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;

- (void)titleDidChange;
- (void)subtitleDidChange;
- (void)imageDidChange;
@end

NS_ASSUME_NONNULL_END
