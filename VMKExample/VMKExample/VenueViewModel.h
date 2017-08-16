//
//  VenueViewModel.h
//  VMKExample
//
//  Created by Andre Trettin on 27/07/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import <ViewModelKit/ViewModelKit.h>
#import "VenueModel.h"

@interface VenueViewModel : VMKViewModel<VenueModel *>
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger venueId;
@end
