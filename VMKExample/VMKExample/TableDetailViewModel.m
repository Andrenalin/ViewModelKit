//
//  TableDetailViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "TableDetailViewModel.h"

@implementation TableDetailViewModel

#pragma mark - init

- (instancetype)initWithName:(NSString *)name price:(nonnull NSString *)price amount:(nonnull NSString *)amount {
    
    self = [super init];
    if (self) {
        _name = name;
        _price = price;
        _amount = amount;
    }
    return self;
}

@end
