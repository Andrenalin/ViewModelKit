//
//  VMKArrayModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "FakeObject.h"
#import "VMKArrayModel+Private.h"

@interface VMKArrayModelTests : XCTestCase
@property (nonatomic, strong) VMKArrayModel *sut;

@property (nonatomic, strong) FakeObject *fakeObject;
@end

@implementation VMKArrayModelTests

- (void)setUp {
    [super setUp];

    self.sut = [[VMKArrayModel alloc] initWithArray:@[]];
    
    self.fakeObject = [[FakeObject alloc] init];
}

- (void)tearDown {
    self.fakeObject = nil;
    
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsContentsToEmpty {
    assertThat(self.sut.contents, hasCountOf(0));
}

- (void)testInitSetsArrayToEmpty {
    assertThat(self.sut.array, hasCountOf(0));
}

#pragma mark - count

- (void)testCountIsZero {
    assertThatUnsignedInteger(self.sut.count, equalToUnsignedInteger(0));
}

- (void)testCountIsOne {
    [self.sut addObject:self.fakeObject];

    assertThatUnsignedInteger(self.sut.count, equalToUnsignedInteger(1));
}

- (void)testCountIsTwo {
    [self.sut addObject:self.fakeObject];
    [self.sut addObject:self.fakeObject];
    
    assertThatUnsignedInteger(self.sut.count, equalToUnsignedInteger(2));
}

#pragma mark - objectAtIndex:

- (void)testObjectAtIndexThrowsIfIndexNotExists {
    XCTAssertThrows([self.sut objectAtIndex:0]);
}

- (void)testObjectAtIndexReturnsObject {
    [self.sut addObject:self.fakeObject];

    assertThat([self.sut objectAtIndex:0], is(self.fakeObject));
}

#pragma mark - indexOfObject:

- (void)testIndexOfObjectFakeNortFound {
    assertThatUnsignedInteger([self.sut indexOfObject:self.fakeObject], equalToUnsignedInteger(NSNotFound));
}

- (void)testIndexOfObjectIsZero {
    [self.sut addObject:self.fakeObject];

    assertThatUnsignedInteger([self.sut indexOfObject:self.fakeObject], equalToUnsignedInteger(0));
}

#pragma mark - addObject

- (void)testAddObjectWithOneObject {
    [self.sut addObject:self.fakeObject];
    
    assertThat(self.sut.array, containsIn(@[self.fakeObject]));
}

- (void)testAddObjectWithTwoObjects {
    FakeObject *fakeObject = [[FakeObject alloc] init];
    [self.sut addObject:fakeObject];
    
    [self.sut addObject:self.fakeObject];
    
    assertThat(self.sut.array, containsIn(@[fakeObject, self.fakeObject]));
}

#pragma mark - removeObject

- (void)testRemoveObjectThatIsNotExistDoesNotThrow {
    XCTAssertNoThrow([self.sut removeObject:self.fakeObject]);
}

- (void)testRemoveObjectRemovesIt {
    [self.sut addObject:self.fakeObject];
    
    [self.sut removeObject:self.fakeObject];
    
    assertThat(self.sut.array, hasCountOf(0));
}

#pragma mark - replaceObjectAtIndex

- (void)testReplaceObjectAtIndexZeroWithANewOne {
    [self.sut addObject:self.fakeObject];
    FakeObject *fakeObject = [[FakeObject alloc] init];

    [self.sut replaceObjectAtIndex:0 withObject:fakeObject];
    
    assertThat(self.sut.array, containsIn(@[fakeObject]));
}

@end
