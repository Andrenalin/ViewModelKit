//
//  VMKObservable+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 19.04.17.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "VMKObservable.h"
#import "VMKBindingUpdater+Private.h"
#import "NSObject+VMKCheckKVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKObservable ()
@property (nonatomic, strong, nonnull) id object;
@property (nonatomic, copy, nonnull) NSString *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions kvoOptions;
@property (nonatomic, strong, nonnull) VMKBindingUpdater *bindingUpdater;
@property (nonatomic, assign, readwrite, getter=isObserving) BOOL observing;
@end

NS_ASSUME_NONNULL_END
