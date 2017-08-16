//
//  VMKObservableManager+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 26/07/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKObservableManager.h"
#import "VMKObservable.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKObservableManager ()
@property (nonatomic, strong, nonnull) NSMutableArray <VMKObservable *> *observables;
@end

NS_ASSUME_NONNULL_END
