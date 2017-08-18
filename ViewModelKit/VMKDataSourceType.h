//
//  VMKDataSourceType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 06.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKDataSourceDelegate.h"
#import "VMKCellType.h"
#import "VMKHeaderFooterType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VMKDataSourceType <NSObject>
@property (nonatomic, weak) id<VMKDataSourceDelegate> delegate;

- (NSInteger)sections;
- (NSInteger)rowsInSection:(NSInteger)section;

- (nullable __kindof VMKViewModel<VMKCellType> *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

@optional
// sections header and footers
- (nullable VMKViewModel<VMKHeaderFooterType> *)headerViewModelAtSection:(NSInteger)section;
- (nullable NSString *)titleForHeaderInSection:(NSInteger)section;
- (nullable NSString *)titleForFooterInSection:(NSInteger)section;

// section index
- (nullable NSArray<NSString *> *)sectionIndexTitles;
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

// editing
- (void)setEditing:(BOOL)editing;
@end

NS_ASSUME_NONNULL_END
