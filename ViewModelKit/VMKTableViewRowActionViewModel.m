//
//  VMKTableViewRowActionViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 22/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKTableViewRowActionViewModel.h"

@interface VMKTableViewRowActionViewModel ()
@property (nonatomic, copy, readwrite, nullable) NSString *title;
@property (nonatomic, assign, readwrite) VMKTableViewRowActionViewModelStyle style;
@property (nonatomic, strong, readwrite, nullable) UIColor *backgroundColor;
@end

@implementation VMKTableViewRowActionViewModel

- (instancetype)initWithTitle:(nullable NSString *)title style:(VMKTableViewRowActionViewModelStyle)style backgroundColor:(nullable UIColor *)backgroundColor delegate:(nullable id<VMKTableViewRowActionViewModelDelegate>)delegate {
    self = [super initWithModel:nil];
    if (self) {
        _title = title;
        _style = style;
        _backgroundColor = backgroundColor;
        _delegate = delegate;
    }
    return self;
}

- (nullable VMKViewModel *)swipedRowActionAtIndexPath:(NSIndexPath *)indexPath {
    return [self.delegate tableViewRowActionViewModel:self rowActionIndexPath:indexPath];
}

@end
