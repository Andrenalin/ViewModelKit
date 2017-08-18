//
//  TableCellViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "TableCellViewModel.h"

#import "TableDetailViewModel.h"

@interface TableCellViewModel ()
// protocol VMKCellType
@property (nonatomic, weak, readwrite, nullable) VMKViewModel *viewModel;

@property (nonatomic, copy, readwrite, nullable) NSString *name;
@property (nonatomic, copy, readwrite, nullable) NSString *price;
@property (nonatomic, copy, readwrite, nullable) NSString *amount;
@end


@implementation TableCellViewModel

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

- (VMKViewModel *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    
    TableDetailViewModel *livm = [[TableDetailViewModel alloc] initWithName:self.name price:self.price amount:self.amount];
    _viewModel = livm;
    return livm;
}

@end
