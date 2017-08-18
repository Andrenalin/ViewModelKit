//
//  CellViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "CellViewModel.h"
#import "SomeData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CellViewModel ()

// protocol VMKCellViewModelType
@property (nonatomic, copy, readwrite, nullable) NSString *title;
@property (nonatomic, copy, readwrite, nullable) NSString *subtitle;
@property (nonatomic, strong, readwrite, nullable) UIImage *image;
@property (nonatomic, weak, readwrite, nullable) VMKViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END


@implementation CellViewModel

#pragma mark - binding

- (VMKBindingDictionary *)modelBindings {
    
    return @{
             @"title":
                 [self bindingUpdaterOnSelector:@selector(titleDidChange)],
             @"subtitle":
                 [self bindingUpdaterOnSelector:@selector(subtitleDidChange)],
             };
}

- (void)titleDidChange {
    self.title = self.model.title;
}

- (void)subtitleDidChange {
    self.subtitle = self.model.subtitle;
}

#pragma mark - VMKCellType

- (VMKViewModel *)viewModel {
    return nil;
}

@end
