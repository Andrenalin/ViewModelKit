//
//  VMKTabViewHeaderFooterViewModelType.h
//  ViewModelKit
//
//  Created by Daniel Seebach on 10.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKHeaderFooterType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKViewHeaderFooterType <NSObject>
@property (nonatomic, strong) __kindof VMKViewModel<VMKHeaderFooterType> *viewModel;
@end

NS_ASSUME_NONNULL_END
