//
//  VMKArrayDataSource+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 30/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKArrayDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKArrayDataSource ()
@property (nonatomic, copy, nullable) NSArray<__kindof VMKViewModel<VMKCellType> *> *viewModels;
@end

NS_ASSUME_NONNULL_END
