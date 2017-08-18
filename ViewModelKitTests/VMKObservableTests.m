//
//  VMKObservableTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKObservable+Private.h"
#import "FakeObject.h"

@interface VMKObservableTests : XCTestCase
@property (nonatomic, strong) VMKObservable *sut;
@property (nonatomic, strong) VMKBindingUpdater *bindingUpdater;
@property (nonatomic, strong) FakeObject *fakeObject;
@end

@implementation VMKObservableTests

- (void)setUp {
    [super setUp];
    
    self.fakeObject = [[FakeObject alloc] init];
    self.bindingUpdater = [[VMKBindingUpdater alloc] initWithObserver:self.fakeObject updateAction:@selector(someAction)];

    self.sut = [[VMKObservable alloc] initWithObject:self.fakeObject forKeyPath:NSStringFromSelector(@selector(observableProperty)) bindingUpdater:self.bindingUpdater];
}

- (void)tearDown {
    self.fakeObject = nil;
    self.bindingUpdater = nil;
    
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsObservingToNo {
    assertThatBool(self.sut.observing, isFalse());
}

#pragma mark - startObservation

- (void)testStartObservationThrowsExceptionIfKeyPathIsNotAProperty {
    self.sut.keyPath = NSStringFromSelector(@selector(someAction));
    
    XCTAssertThrows([self.sut startObservation]);
}

- (void)testStartObservationSetsObservingToYes {
    [self.sut startObservation];
    
    assertThatBool(self.sut.observing, isTrue());
}

#pragma mark - observeValueForKeyPath:

- (void)testObserveStringSetsChangeOnBindingUpdater {
    [self.sut startObservation];
    
    self.fakeObject.observableProperty = @"New Testvalue";
    
    assertThat(self.bindingUpdater.change, notNilValue());
    assertThat(self.bindingUpdater.change, hasEntry(NSKeyValueChangeNewKey, @"New Testvalue"));
}

- (void)testObserveValueForKeyPathCallsSuperAndThrows {
    XCTAssertThrows([self.sut observeValueForKeyPath:@"accessibilityHint" ofObject:self change:nil context:nil]);
}

#pragma mark - isKeyPath

- (void)testIsKeyPathReturnsNoWithDifferentSelector {
    assertThatBool([self.sut isKeyPath:@"differentSelectorPath"], isFalse());
}

- (void)testIsKeyPathReturnsYesWithTheSameSelector {
    assertThatBool([self.sut isKeyPath:NSStringFromSelector(@selector(observableProperty))], isTrue());
}

#pragma mark - isObserver

- (void)testIsObserverReturnsNoWithDifferentObject {
    assertThatBool([self.sut isObserver:self], isFalse());
}

- (void)testIsObserverReturnsYesWithTheSameObject {
    assertThatBool([self.sut isObserver:self.fakeObject], isTrue());
}

#pragma mark - isObject

- (void)testIsObjectReturnsNoWithDifferentObject {
    NSObject *someObject = [NSObject new];
    
    assertThatBool([self.sut isObject:someObject], isFalse());
}

- (void)testIsObjectReturnsYesWithTheSameObject {
    assertThatBool([self.sut isObject:self.fakeObject], isTrue());
}

#pragma mark - description

- (void)testDescriptionHasSubStringBindingUpdater {
    NSString *result = self.sut.description;
    assertThat(result, containsSubstring(@"updater: <VMKBindingUpdater:"));
}

- (void)testDescriptionHasSubStringFakeObject {
    NSString *result = self.sut.description;
    assertThat(result, containsSubstring(@"Object:<FakeObject:"));
}

- (void)testDescriptionHasSubStringKeyPathObservableProperty {
    NSString *result = self.sut.description;
    assertThat(result, containsSubstring(@"KeyPath:observableProperty"));
}

@end
