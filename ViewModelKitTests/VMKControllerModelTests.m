//
//  VMKControllerModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 13/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKControllerModel.h"

@interface VMKControllerModelTests : XCTestCase
@property (nonatomic, strong) VMKControllerModel *sut;
@end

@implementation VMKControllerModelTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKControllerModel alloc] init];
}

- (void)tearDown {
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsEditingToNo {
    assertThatBool(self.sut.editing, isFalse());
}

#pragma mark - controllerModelForSegue:

- (void)testControllerModelForSegueReturnsNotNil {
    UIStoryboardSegue *mockSeque = mock([UIStoryboardSegue class]);
    
    assertThat([self.sut controllerModelForSegue:mockSeque], notNilValue());
}

- (void)testControllerModelForSegueReturnsControllerModelEditingIsYes {
    UIStoryboardSegue *mockSeque = mock([UIStoryboardSegue class]);
    self.sut.editing = YES;
    
    assertThatBool([self.sut controllerModelForSegue:mockSeque].editing, isTrue());
}

@end
