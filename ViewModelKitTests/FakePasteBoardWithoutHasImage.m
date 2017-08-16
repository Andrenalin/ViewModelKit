//
//  FakePasteBoardWithoutHasImage.m
//  ViewModelKit
//
//  Created by Andre Trettin on 13/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "FakePasteBoardWithoutHasImage.h"

@implementation FakePasteBoardWithoutHasImage

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _returnImage = image;
    }
    return self;
}

- (UIImage *)image {
    return self.returnImage;
}

@end
