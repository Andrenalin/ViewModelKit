//
//  VenueControllerAsViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 30.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VenueControllerAsViewModel.h"

@interface VenueControllerAsViewModel ()
@property (nonatomic, strong, readwrite) VenueModel *venueModel;
@end

@implementation VenueControllerAsViewModel

- (instancetype)initWithVenueModel:(VenueModel *)venueModel {
    self = [super init];
    if (self) {
        _venueModel = venueModel;
        [self.observableManager addObject:_venueModel withBindings:[self bindings]];
    }
    return self;
}

- (VMKBindingDictionary *)bindings {
    return @{
             NSStringFromSelector(@selector(name)):
                 [self bindingUpdaterOnSelector:@selector(nameDidChanged)],
             NSStringFromSelector(@selector(venueId)):
                 [self bindingUpdaterOnSelector:@selector(venueIdDidChanged)]
             };
}

#pragma mark - binding did changed

- (void)nameDidChanged {
    NSLog(@"Name has changed to %@", self.venueModel.name);
    // do some action
}

- (void)venueIdDidChanged {
    NSLog(@"Venue ID has changed to %@", self.venueModel.venueId);
    // do some action
}

@end
