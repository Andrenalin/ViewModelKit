//
//  VMKView.m
//  ViewModelKit
//
//  Created by Andre Trettin on 15/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKView.h"

@implementation VMKView

static NSString * const VMKViewPreferedSizeKey = @"VMKViewPreferedSize";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.preferedSize = [aDecoder decodeCGSizeForKey:VMKViewPreferedSizeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeCGSize:self.preferedSize forKey:VMKViewPreferedSizeKey];
}

- (CGSize)intrinsicContentSize {
    return self.preferedSize;
}

@end
