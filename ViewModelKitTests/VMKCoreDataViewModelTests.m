//
//  VMKCoreDataViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKCoreDataViewModel+Private.h"

@interface VMKCoreDataViewModelTests : XCTestCase
@property (nonatomic, strong) VMKCoreDataViewModel *sut;

@property (nonatomic, strong) NSManagedObject *mockManagedObject;
@property (nonatomic, strong) VMKObservableManager *mockObserverableManager;
@property (nonatomic, strong) NSManagedObjectContext *mockManagedObjectContext;
@end

@implementation VMKCoreDataViewModelTests

- (void)setUp {
    [super setUp];
    
    self.mockManagedObject = mock([NSManagedObject class]);
    self.sut = [[VMKCoreDataViewModel alloc] initWithModel:self.mockManagedObject];
    
    self.mockObserverableManager = mock([VMKObservableManager class]);
    self.sut.observableManager = self.mockObserverableManager;
    
    self.mockManagedObjectContext = mock([NSManagedObjectContext class]);
    [given(self.mockManagedObject.managedObjectContext) willReturn:self.mockManagedObjectContext];
}

- (void)tearDown {
    self.mockManagedObject = nil;
    self.mockObserverableManager = nil;
    self.mockManagedObjectContext = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsObjectToMock {
    assertThat(self.sut.model, is(self.mockManagedObject));
}

- (void)testInitSetsObservableManagerToMock {
    assertThat(self.sut.observableManager, is(self.mockObserverableManager));
}

#pragma mark - setObject:

- (void)testSetObjectCallsRemovesObserverForPreviousObject {
    [self.sut startModelObservation];
    
    self.sut.model = nil;
    
    [verifyCount(self.mockObserverableManager, times(1)) removeObserverForObject:self.mockManagedObject];
}

- (void)testSetObjectCallsAddObjectWithBinding {
    NSManagedObject *mockNewObject = mock([NSManagedObject class]);
    
    self.sut.model = mockNewObject;
    
    [[verifyCount(self.mockObserverableManager, times(1)) withMatcher:anything() forArgument:1] addObject:mockNewObject withBindings:anything()];
}

#pragma mark - coreDataBindings

- (void)testCoreDataBindingsIsNotNil {
    assertThat(self.sut.modelBindings, notNilValue());
}

- (void)testCoreDataBindingsIsNotEmoty {
    assertThat(self.sut.modelBindings, hasCountOf(0));
}

#pragma mark - saveCoreDataObject:

- (void)testSaveCoreDataObjectReturnsYesIfObjectIsNil {
    self.sut.model = nil;
    
    assertThatBool([self.sut saveCoreDataObject:nil], isTrue());
}

- (void)testSaveCoreDataObjectCallsSaveOnManagedObjectContext {
    [self.sut saveCoreDataObject:nil];
    
    [verifyCount(self.mockManagedObjectContext, times(1)) save:nil];
}

#pragma mark - deleteObject

- (void)testDeleteObjectCallsDeleteObjectOnManagedObjectContext {
    [self.sut deleteObject];
    
    [verifyCount(self.mockManagedObjectContext, times(1)) deleteObject:self.mockManagedObject];
}

- (void)testDeleteObjectSetsObjectToNil {
    [self.sut deleteObject];
    
    assertThat(self.sut.model, nilValue());
}

- (void)testDeleteObjectCallsRemovesObserverForPreviousObject {
    [self.sut deleteObject];
    
    [verifyCount(self.mockObserverableManager, times(1)) removeObserverForObject:self.mockManagedObject];
}

#pragma mark - resetObject:

- (void)testResetObjectSetsObject {
    NSManagedObject *mockNewObject = mock([NSManagedObject class]);
    
    [self.sut resetObject:mockNewObject];

    assertThat(self.sut.model, is(mockNewObject));
}

@end
