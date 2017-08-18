//
//  VMKHeaderFooterType.h
//  ViewModelKit
//
//  Created by Daniel Seebach on 10.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKHeaderFooterType <NSObject>
- (nullable __kindof VMKViewModel *)viewModel;

@optional
// this is only needed for System UITableHeaderFooterView
- (nullable NSString *)title;
- (nullable NSString *)subtitle;
@end

NS_ASSUME_NONNULL_END
