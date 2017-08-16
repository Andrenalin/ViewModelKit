//
//  NSObject+VMKCheckKVO.h
//  ViewModelKit
//
//  Created by Andre Trettin on 17.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (VMKCheckKVO)
- (BOOL)vmk_canSetValueForKey:(NSString *)key;
- (BOOL)vmk_canSetValueForKeyPath:(NSString *)keyPath;
@end

NS_ASSUME_NONNULL_END
