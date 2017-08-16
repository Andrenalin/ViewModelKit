//
//  VenueController.m
//  VMKExample
//
//  Created by Andre Trettin on 01/08/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import <ViewModelKit/ViewModelKit.h>

#import "VenueController.h"

@interface VenueController ()
@property (nonatomic, strong) VMKObservable *observable;
@end

@implementation VenueController

- (void)setObservables {
    VMKBindingUpdater *bu = [[VMKBindingUpdater alloc] initWithObserver:self updateAction:@selector(updateName)];
    
    self.observable = [[VMKObservable alloc] initWithObject:self.venueModel forKeyPath:NSStringFromSelector(@selector(name)) bindingUpdater:bu];
    [self.observable startObservation];
}

- (void)updateName {
    // do something
    //self.venueModel.name
}

@end
