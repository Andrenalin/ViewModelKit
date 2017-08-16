//
//  VMKControllerModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 16.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKControllerModel.h"

@implementation VMKControllerModel

- (nullable __kindof VMKControllerModel *)controllerModelForSegue:(UIStoryboardSegue *)segue {
    VMKControllerModel *cm = [[[self class] alloc] init];
    cm.editing = self.editing;
    return cm;
}

@end
