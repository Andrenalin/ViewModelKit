//
//  VMKControllerModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 16.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

#import "VMKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKControllerModel : VMKViewModel
@property (nonatomic, assign) BOOL editing;

- (nullable __kindof VMKControllerModel *)controllerModelForSegue:(UIStoryboardSegue *)segue;
@end

NS_ASSUME_NONNULL_END
