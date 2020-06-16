//
//  VMKCollectionReusableHeaderView.h
//  ViewModelKit
//
//  Created by Peter Darbey on 08/06/2020.
//  Copyright © 2020 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewHeaderFooterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKCollectionReusableHeaderView<__covariant HeaderViewModel:__kindof VMKViewModel<VMKHeaderFooterType> *> : UICollectionReusableView <VMKViewHeaderFooterType>

@property (class, nonatomic, copy, readonly) NSString *reuseIdentifier;
@property (nonatomic, strong, nullable) HeaderViewModel viewModel;

- (VMKBindingDictionary *)viewModelBindings;

@end

NS_ASSUME_NONNULL_END
