//
//  TableViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "TableViewModel.h"

#import "TableCellViewModel.h"

@interface TableViewModel ()
// protocol VMKDataSourceViewModelType
@property (nonatomic, strong, readwrite) VMKDataSource *dataSource;

@property (nonatomic, strong) NSArray<__kindof TableCellViewModel *> *tableCellViewModels;
@end

@implementation TableViewModel

#pragma mark - VMKDataSourceViewModelType protocol

- (VMKDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[VMKArrayDataSource alloc] initWithViewModels:self.tableCellViewModels];
    }
    return _dataSource;
}

#pragma mark - accessors

- (NSArray<__kindof TableCellViewModel *> *)tableCellViewModels {
    if (!_tableCellViewModels) {
        _tableCellViewModels = [self models];
    }
    return _tableCellViewModels;
}

#pragma mark - helper

- (NSArray<__kindof TableCellViewModel *> *)models {
    
    TableCellViewModel *tcvm = nil;
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:5];

    tcvm = [[TableCellViewModel alloc] initWithName:@"Name 1" price:@"1.00" amount:@"1"];
    [models addObject:tcvm];
    tcvm = [[TableCellViewModel alloc] initWithName:@"Name 2" price:@"2.00" amount:@"2"];
    [models addObject:tcvm];
    tcvm = [[TableCellViewModel alloc] initWithName:@"Name 3" price:@"3.00" amount:@"3"];
    [models addObject:tcvm];
    tcvm = [[TableCellViewModel alloc] initWithName:@"Name 4" price:@"4.00" amount:@"4"];
    [models addObject:tcvm];
    tcvm = [[TableCellViewModel alloc] initWithName:@"Name 5" price:@"5.00" amount:@"5"];
    [models addObject:tcvm];
    
    return models;
}

@end
