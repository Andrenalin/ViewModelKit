//
//  UIViewTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "UIView+VMKInspectables.h"

@interface UIViewTests : XCTestCase
@property (nonatomic, strong) UIView *sut;
@end

@implementation UIViewTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[UIView alloc] init];
}

- (void)tearDown {
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

#pragma mark - setBorderColor:

- (void)testSetBorderColorSetsColor {
    self.sut.borderColor = [UIColor redColor];
    
    assertThat(self.sut.borderColor, is([UIColor redColor]));
}

- (void)testBorderColorIsClearColor {
    self.sut.layer.borderColor = nil;
    
    assertThat(self.sut.borderColor, is([UIColor clearColor]));
}

#pragma mark - setBorderWidth:

- (void)testSetBorderWidthSetsWidth {
    self.sut.borderWidth = 42.0f;
    
    assertThatInteger((NSInteger)self.sut.borderWidth, equalToInteger(42));
}

#pragma mark - setCornerRadius:

- (void)testSetCornerRadiusSetsRadius {
    self.sut.cornerRadius = 42.0f;
    
    assertThatInteger((NSInteger)self.sut.cornerRadius, equalToInteger(42));
}

@end
