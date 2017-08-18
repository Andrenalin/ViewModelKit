//
//  VMKBindingUpdaterTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;

#import "VMKBindingUpdater.h"
#import "FakeObject.h"

@interface VMKBindingUpdaterTests : XCTestCase
@property (nonatomic, strong) VMKBindingUpdater *sut;
@property (nonatomic, strong) FakeObject *fakeObject;
@end

@implementation VMKBindingUpdaterTests

- (void)setUp {
    [super setUp];
    self.fakeObject = [[FakeObject alloc] init];
    self.sut = [[VMKBindingUpdater alloc] initWithObserver:self.fakeObject updateAction:@selector(someAction)];
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

- (void)testInitWithnotImplementedActionWillThrowException {
    SEL action = @selector(testSutIsNotNil);
    XCTAssertThrows([[VMKBindingUpdater alloc] initWithObserver:self.fakeObject updateAction:action]);
}

#pragma mark - bindingUpdaterWithObserver:updateAction:

- (void)testBindingUpdaterWithObserverIsFakeObjectUpdateActionIsTestActionIsNotNil {
    VMKBindingUpdater *sut = [VMKBindingUpdater bindingUpdaterWithObserver:self.fakeObject updateAction:@selector(someAction)];
    assertThat(sut, notNilValue());
}

#pragma mark - update

- (void)testUpdateCallsAction {
    [self.sut update];
    assertThatUnsignedInteger(self.fakeObject.calledSomeAction, equalToUnsignedInteger(1));
}

- (void)testUpdateCallsActionTwice {
    [self.sut update];
    [self.sut update];
    assertThatUnsignedInteger(self.fakeObject.calledSomeAction, equalToUnsignedInteger(2));
}

- (void)testUpdateDoesNotCrashIfObjectAlreadyDeallocated {
    self.fakeObject = nil;
    XCTAssertNoThrow([self.sut update]);
}

#pragma mark - isObserver

- (void)testIsObserverWithFakeObjectReturnsYES {
    BOOL result = [self.sut isObserver:self.fakeObject];
    assertThatBool(result, isTrue());
}

- (void)testIsObserverWithAnyOtherObjectReturnsNO {
    BOOL result = [self.sut isObserver:self];
    assertThatBool(result, isFalse());
}

#pragma mark - description

- (void)testDescriptionHasSubStringSelectorTestAction {
    NSString *result = self.sut.description;
    assertThat(result, containsSubstring(@"updateAction:someAction"));
}

- (void)testDescriptionHasSubStringFakeObject {
    NSString *result = self.sut.description;
    assertThat(result, containsSubstring(@"observer:<FakeObject:"));
}

@end
