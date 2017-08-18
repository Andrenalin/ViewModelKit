//
//  FakeObject.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "FakeObject.h"

@implementation FakeObject
{
    BOOL _isBoolProperty;
}

- (void)someAction {
    ++self.calledSomeAction;
}

@end
