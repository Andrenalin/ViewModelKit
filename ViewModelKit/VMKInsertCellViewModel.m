//
//  VMKInsertCellViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 31.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKInsertCellViewModel.h"

@interface VMKInsertCellViewModel ()
@property (nonatomic, strong, readwrite, nullable) VMKViewModel *viewModel;
@property (nonatomic, copy, readwrite, nullable) NSString *title;
@end

@implementation VMKInsertCellViewModel

#pragma mark - init

- (instancetype)initWithDelegate:(id<VMKInsertCellViewModelDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - VMKCellType

- (NSString *)title {
    if (_title) {
        return _title;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    _title =  NSLocalizedStringWithDefaultValue(@"Insert_Cell_Default_Title", @"DefaultViewModelKit", bundle, @"Insert", @"The default title of any insert cells");
    return _title;
}

- (BOOL)canEdit {
    return YES;
}

- (BOOL)canInsert {
    return YES;
}

- (void)insertData {
    [self.delegate insertDataInsertCellViewModel:self];
}

@end
