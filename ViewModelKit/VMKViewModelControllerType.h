//
//  VMKViewModelControllerType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 12.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

@class VMKControllerModel;
@class VMKViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKViewModelControllerType <NSObject>
@property (nonatomic, strong, nullable) __kindof VMKControllerModel *controllerModel;
@property (nonatomic, strong, nullable) __kindof VMKViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
