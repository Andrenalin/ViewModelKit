//
//  NSObject+VMKCheckKVOTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 20/03/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "NSObject+VMKCheckKVO.h"
#import "FakeObject.h"

@interface NSObjectTests : XCTestCase
@property (nonatomic, strong) FakeObject *sut;
@end

@implementation NSObjectTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[FakeObject alloc] init];
}

- (void)tearDown {
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

#pragma mark - vmk_canSetValueForKey:

- (void)testCanSetValueForKey {
    assertThatBool([self.sut vmk_canSetValueForKey:@"isBoolProperty"], isTrue());
}

#pragma mark - vmk_canSetValueForKeyPath:

- (void)testCanSetValueForKeyPathEmptyKey {
    assertThatBool([self.sut vmk_canSetValueForKeyPath:@""], isFalse());
}

- (void)testCanSetValueForKeyPathEmptyKeyPath {
    assertThatBool([self.sut vmk_canSetValueForKeyPath:@"."], isFalse());
}

- (void)testCanSetValueForKeyPathWithFirstKeyPath {
    assertThatBool([self.sut vmk_canSetValueForKeyPath:@"observableProperty."], isFalse());
}

- (void)testCanSetValueForKeyPathWithFullKeyPathReturnsNo {
    assertThatBool([self.sut vmk_canSetValueForKeyPath:@"observableProperty.accessibilityHint"], isFalse());
}

@end
