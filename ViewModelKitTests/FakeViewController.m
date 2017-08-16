//
//  FakeViewController.m
//  ViewModelKit
//
//  Created by Andre Trettin on 31.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "FakeViewController.h"

@interface FakeViewController ()

@end

@implementation FakeViewController

- (void)updateActionTest {
    
}

- (VMKBindingDictionary *)viewModelBindings {
    
    static VMKBindingDictionary *dict = nil;
    
    if (!dict) {
        dict = @{ @"name": [self bindingUpdaterOnSelector:@selector(updateActionTest)] };
    }
    
    return dict;
}

@end
