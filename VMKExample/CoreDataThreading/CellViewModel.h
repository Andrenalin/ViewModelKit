//
//  CellViewModel.h
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import ViewModelKit;

#import "SomeData+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CellViewModel : VMKCoreDataViewModel<SomeData *> <VMKCellType>
@end

NS_ASSUME_NONNULL_END
