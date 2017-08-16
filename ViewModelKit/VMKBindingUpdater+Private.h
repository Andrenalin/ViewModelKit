//
//  VMKBindingUpdater+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKBindingUpdater.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKBindingUpdater ()
@property (nonatomic, strong, readwrite, nullable) NSDictionary<NSKeyValueChangeKey, id> *change;

@property (weak, nonatomic) id observer;
@property (assign, nonatomic) SEL updateAction;
@property (assign, nonatomic) BOOL updateActionsTakesBindingUpdaterParam;
@end

NS_ASSUME_NONNULL_END
