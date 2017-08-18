//
//  VMKTableViewHeaderFooterView.h
//  ViewModelKit
//
//  Created by Daniel Seebach on 10.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewHeaderFooterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewHeaderFooterView<__covariant CellViewModel:__kindof VMKViewModel<VMKHeaderFooterType> *> : UITableViewHeaderFooterView <VMKViewHeaderFooterType>

@property (class, nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, strong, nullable) CellViewModel viewModel;

- (VMKBindingDictionary *)viewModelBindings;
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;

- (void)titleDidChange;
- (void)subtitleDidChange;
@end

NS_ASSUME_NONNULL_END
