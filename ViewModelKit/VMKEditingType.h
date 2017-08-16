//
//  VMKEditingType.h
//  ViewModelKit
//
//  Created by Andre Trettin on 28/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKEditingType <NSObject>
@property (nonatomic, assign) BOOL editing;
- (BOOL)save;
@end

NS_ASSUME_NONNULL_END
