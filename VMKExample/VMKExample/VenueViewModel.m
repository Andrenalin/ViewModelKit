//
//  VenueViewModel.m
//  VMKExample
//
//  Created by Andre Trettin on 27/07/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VenueViewModel.h"

@interface VenueViewModel ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign, readwrite) NSInteger venueId;
@end


@implementation VenueViewModel

#pragma mark - binding 

- (VMKBindingDictionary *)modelBindings {
    return @{ @"name":
                  [self bindingUpdaterOnSelector:@selector(updateName)],
              @"venueId":
                  [self bindingUpdaterOnSelector:@selector(updateVenueId)],
             };
}

#pragma mark - update

- (void)updateName {
    self.name = self.model.name;
}

- (void)updateVenueId {
    self.venueId = [self.model.venueId integerValue];
}

@end
