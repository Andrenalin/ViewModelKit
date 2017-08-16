//
//  VMKInsertCellViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 31.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKCellType.h"

NS_ASSUME_NONNULL_BEGIN

@class VMKInsertCellViewModel;

@protocol VMKInsertCellViewModelDelegate <NSObject>
- (void)insertDataInsertCellViewModel:(VMKInsertCellViewModel *)insertCellViewModel;
@end


@interface VMKInsertCellViewModel : VMKViewModel<VMKCellType>
@property (nonatomic, weak) id<VMKInsertCellViewModelDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<VMKInsertCellViewModelDelegate>)delegate;

- (void)insertData;
@end

NS_ASSUME_NONNULL_END
