//
//  VenueModel.h
//  VMKExample
//
//  Created by Andre Trettin on 27/07/16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

@interface VenueModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *venueId;
@property (nonatomic, assign) NSInteger *internalId;
@end
