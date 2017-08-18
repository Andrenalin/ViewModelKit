//
//  VenueControllerAsViewModel.h
//  VMKExample
//
//  Created by Andre Trettin on 30.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;
@import ViewModelKit;

#import "VenueModel.h"

@interface VenueControllerAsViewModel : VMKViewModel
@property (nonatomic, strong, readonly) VenueModel *venueModel;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(id)model NS_UNAVAILABLE;
- (instancetype)initWithVenueModel:(VenueModel *)venueModel NS_DESIGNATED_INITIALIZER;
@end
