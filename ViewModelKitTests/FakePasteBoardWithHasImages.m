//
//  FakePasteBoardWithHasImages.m
//  ViewModelKit
//
//  Created by Andre Trettin on 13/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "FakePasteBoardWithHasImages.h"

@implementation FakePasteBoardWithHasImages

- (instancetype)initWithImage:(UIImage *)image hasImage:(BOOL)hasImage {
    self = [super init];
    if (self) {
        _returnImage = image;
        _returnHasImage = hasImage;
    }
    return self;
}

- (BOOL)hasImages {
    return self.returnHasImage;
}

@end
