//
//  VMKViewModel+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 29/07/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKViewModel ()
@property (strong, nonatomic, readwrite) VMKObservableManager *observableManager;

/// The external observable manager to manage external bindings from the view model to any owner object.
@property (strong, nonatomic) VMKObservableManager *externalBindingManager;

@property (nonatomic, assign, readwrite) BOOL observingModel;
@end

NS_ASSUME_NONNULL_END
