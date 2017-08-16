//
//  VMKObserverNotificationManagerTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKObserverNotificationManager+Private.h"
#import "FakeNotificationCenter.h"

@interface VMKObserverNotificationManagerTests : XCTestCase
@property (strong, nonatomic) VMKObserverNotificationManager *sut;
@property (strong, nonatomic) FakeNotificationCenter *fakeNotifcationCenter;
@property (strong, nonatomic) id observerObject;
@property (copy, nonatomic) void (^block)(NSNotification *note);
@end


@implementation VMKObserverNotificationManagerTests

#pragma mark - fixture

- (void)setUp {
    [super setUp];
    self.fakeNotifcationCenter = [[FakeNotificationCenter alloc] init];
    self.fakeNotifcationCenter.addObserverForNameReturnObject = @"testObserver";
    self.block = ^(NSNotification *note) {};
    
    self.sut = [[VMKObserverNotificationManager alloc] initWithNotificationCenter:(id)self.fakeNotifcationCenter];
}

- (void)tearDown {
    self.sut = nil;
    self.fakeNotifcationCenter = nil;
    self.block = nil;
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testDefaultInitHasDefaultNotificationCenter {
    VMKObserverNotificationManager *defaultObserver = [[VMKObserverNotificationManager alloc] init];
    assertThat(defaultObserver.notificationCenter, is([NSNotificationCenter defaultCenter]));
}

- (void)testInitSetsNotificationCenter {
    assertThat(self.sut.notificationCenter, is(self.fakeNotifcationCenter));
}

#pragma mark - addObserver tests

- (void)testAddObserverCallsNotificationCenterAddObserverForNameWithQueue {
    [self.sut addObserverForName:nil object:nil usingBlock:self.block];
    assertThatUnsignedInteger(self.fakeNotifcationCenter.addObserverForNameCallCount, equalToUnsignedInteger(1));
}

- (void)testAddObserverAddsAnObserver {
    [self.sut addObserverForName:nil object:nil usingBlock:self.block];
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:nil]], hasCountOf(1));
}

- (void)testAddObserverAddsTwoObservers {
    [self.sut addObserverForName:nil object:@"1" usingBlock:self.block];
    [self.sut addObserverForName:nil object:@"2" usingBlock:self.block];
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:nil]], hasCountOf(2));
}

- (void)testAddObserverAddsTwoObserversWithTwoDifferentNamesButSameObject {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test2" object:myObject usingBlock:self.block];
    assertThat([self.sut.noteObservers allKeys], hasCountOf(2));
}

- (void)testAddObserverAddsOnlyOneObserversWithTheNameandSameObject {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:@"test1"]], hasCountOf(1));
}

- (void)testAddingTheObserverNameAndObjectCallsRemoveOnTheOldOne {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    assertThatUnsignedInteger(self.fakeNotifcationCenter.removeObserverCallCount, equalToUnsignedInteger(1));
}

#pragma mark - remvoveObserver tests

- (void)testRemoveObserverWithoutAddedAnyObserver {
    [self.sut removeObservers];
    assertThatUnsignedInteger(self.fakeNotifcationCenter.removeObserverCallCount, equalToUnsignedInteger(0));
}

#pragma mark - remvoveObserver:name:object: tests

- (void)testRemoveObserverCallsNotificationCenterRemoveObserverNameObject {
    [self.sut addObserverForName:nil object:nil usingBlock:self.block];
    [self.sut removeObserverWithName:nil object:nil];
    assertThatUnsignedInteger(self.fakeNotifcationCenter.removeObserverCallCount, equalToUnsignedInteger(1));
}

- (void)testRemoveObserverThePreviousAddedOne {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut removeObserverWithName:@"test1" object:myObject];
    
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:@"test1"]], hasCountOf(0));
}

- (void)testRemoveObserverRemovesTheSpecificNameAndObject {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test1" object:@"3" usingBlock:self.block];
    [self.sut removeObserverWithName:@"test1" object:myObject];
    
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:@"test1"]], hasCountOf(1));
}

- (void)testRemoveObserverRemovesAllSpecificNameObserversIfObjectIsNil {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test1" object:@"3" usingBlock:self.block];
    [self.sut removeObserverWithName:@"test1" object:nil];
    
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:@"test1"]], hasCountOf(0));
}

- (void)testRemoveObserverRemovesNotTheNameObservers {
    NSString *myObject = @"1";
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test2" object:@"3" usingBlock:self.block];
    [self.sut removeObserverWithName:@"test1" object:nil];
    
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:@"test2"]], hasCountOf(1));
}

- (void)testRemoveObserverRemovesNothingIfSpecificObjectIsNotAdded {
    NSString *myObject = @"1";
    self.sut.notificationCenter = [NSNotificationCenter defaultCenter];
    [self.sut addObserverForName:@"test1" object:myObject usingBlock:self.block];
    [self.sut addObserverForName:@"test1" object:@"3" usingBlock:self.block];
    [self.sut removeObserverWithName:@"test1" object:@"4"];
    
    assertThat([self.sut.noteObservers objectForKey:[self.sut noteKey:@"test1"]], hasCountOf(2));
}

@end
