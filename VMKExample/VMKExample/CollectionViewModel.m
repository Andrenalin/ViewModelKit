//
//  CollectionViewModel.m
//  VMKExample
//
//  Created by Daniel Rinser on 09.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "CollectionViewModel.h"
#import "CollectionCellViewModel.h"


@interface CollectionViewModel ()
@property (nonatomic, strong, readwrite) VMKDataSource *dataSource;
@end

@implementation CollectionViewModel

#pragma mark - VMKDataSourceViewModelType

- (VMKDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[VMKArrayDataSource alloc] initWithViewModels:[self cellViewModels]];
    }
    return _dataSource;
}

#pragma mark - Helper

- (NSArray<__kindof VMKViewModel<VMKCellType> *> *)cellViewModels {
    NSMutableArray *cvms = [[NSMutableArray alloc] initWithCapacity:30];

    for (int i = 0; i < 30; ++i) {
        NSString *title = [NSString stringWithFormat:@"Title %d", i];
        NSString *subtitle = [NSString stringWithFormat:@"Subtitle %d", i];
        CollectionCellViewModel *cvm = [[CollectionCellViewModel alloc] initWithTitle:title subtitle:subtitle];
        [cvms addObject:cvm];
    }
    
    return cvms;
}

@end
