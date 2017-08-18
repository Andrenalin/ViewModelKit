//
//  VMKCollectionViewCell.h
//  ViewModelKit
//
//  Created by Daniel Rinser on 04.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewCellType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKCollectionViewCell<__covariant CellViewModel:__kindof VMKViewModel<VMKCellType> *> : UICollectionViewCell <VMKViewCellType>

@property (class, nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, strong, nullable) CellViewModel viewModel;

- (VMKBindingDictionary *)viewModelBindings;
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;
@end

NS_ASSUME_NONNULL_END
