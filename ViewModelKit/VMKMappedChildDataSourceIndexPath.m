//
//  VMKMappedChildDataSourceIndexPath.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKMappedChildDataSourceIndexPath.h"

@implementation VMKMappedChildDataSourceIndexPath

- (instancetype)initWithDataSource:(VMKDataSource *)dataSource offset:(NSInteger)offset indexPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _offset = offset;
        _indexPath = indexPath;
    }
    return self;
}

@end
