//
//  CollectionCellViewModel.h
//  VMKExample
//
//  Created by Daniel Rinser on 09.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import ViewModelKit;

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCellViewModel : VMKViewModel <VMKCellType>
@property (nonatomic, copy, nullable, readonly) NSString *title;
@property (nonatomic, copy, nullable, readonly) NSString *subtitle;

- (instancetype)initWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle;
@end

NS_ASSUME_NONNULL_END
