//
//  CollectionCellViewModel.m
//  VMKExample
//
//  Created by Daniel Rinser on 09.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "CollectionCellViewModel.h"

@interface CollectionCellViewModel ()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *subtitle;
@end


@implementation CollectionCellViewModel

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        _title = [title copy];
        _subtitle = [subtitle copy];
    }
    return self;
}

#pragma mark - VMKCellType

- (VMKViewModel *)viewModel {
    return nil;
}

@end
