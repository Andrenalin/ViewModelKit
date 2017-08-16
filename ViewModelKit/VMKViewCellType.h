//
//  VMKViewCellType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 27/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKCellType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKViewCellType <NSObject>
@property (nonatomic, strong) __kindof VMKViewModel<VMKCellType> *viewModel;
@end

NS_ASSUME_NONNULL_END
