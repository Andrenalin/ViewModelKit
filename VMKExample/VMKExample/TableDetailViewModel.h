//
//  TableDetailViewModel.h
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import ViewModelKit;

NS_ASSUME_NONNULL_BEGIN

@interface TableDetailViewModel : VMKViewModel
@property (nonatomic, copy, readonly, nullable) NSString *name;
@property (nonatomic, copy, readonly, nullable) NSString *price;
@property (nonatomic, copy, readonly, nullable) NSString *amount;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(nullable id)model NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name price:(NSString *)price amount:(NSString *)amount NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
