//
//  VMKArrayUpdaterTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKArrayUpdater.h"
#import "VMKArrayModel.h"
#import "FakeObject.h"

@interface VMKArrayUpdaterTests : XCTestCase
@property (nonatomic, strong) VMKArrayUpdater *sut;
@property (nonatomic, strong) VMKArrayModel *arrayModel;
@property (nonatomic, strong) id<VMKArrayUpdaterDelegate> mockDelegate;
@end

@implementation VMKArrayUpdaterTests

- (void)setUp {
    [super setUp];
    
    self.arrayModel = [[VMKArrayModel alloc] initWithArray:@[]];
    self.mockDelegate = mockProtocol(@protocol(VMKArrayUpdaterDelegate));
    self.sut = [[VMKArrayUpdater alloc] initWithArrayModel:self.arrayModel delegate:self.mockDelegate];
}

- (void)tearDown {
    self.mockDelegate = nil;
    self.arrayModel = nil;
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testArrayDidChange {
    FakeObject *fakeObject = [FakeObject new];
    [self.sut bindArray];
    
    [self.arrayModel addObject:fakeObject];
    
    [verifyCount(self.mockDelegate, times(1)) arrayUpdater:self.sut didChangeWithChangeSet:anything()];
}

- (void)testArrayDidChangeTwice {
    FakeObject *fakeObject = [FakeObject new];
    [self.sut bindArray];
    
    [self.arrayModel addObject:fakeObject];
    [self.arrayModel removeObject:fakeObject];
    
    [verifyCount(self.mockDelegate, times(2)) arrayUpdater:self.sut didChangeWithChangeSet:anything()];
}


@end
