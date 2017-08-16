//
//  VMKInsertCellViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKInsertCellViewModel.h"

@interface VMKInsertCellViewModelTests : XCTestCase
@property (nonatomic, strong) VMKInsertCellViewModel *sut;

@property (nonatomic, strong) id<VMKInsertCellViewModelDelegate> mockDelegate;
@end

@implementation VMKInsertCellViewModelTests

- (void)setUp {
    [super setUp];
    
    self.mockDelegate = mockProtocol(@protocol(VMKInsertCellViewModelDelegate));
    self.sut = [[VMKInsertCellViewModel alloc] initWithDelegate:self.mockDelegate];
}

- (void)tearDown {
    self.mockDelegate = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsDelegateToMock {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

#pragma mark - VMKCellViewModel

- (void)testViewModelIsNil {
    assertThat(self.sut.viewModel, nilValue());
}

- (void)testTitleIsInsert {
    assertThat(self.sut.title, is(@"Insert"));
}

- (void)testTitleTwiceIsSame {
    NSString *first = [self.sut title];
    
    assertThat(self.sut.title, is(first));
}

#pragma mark - can method

- (void)testCanEditIsYes {
    assertThatBool([self.sut canEdit], isTrue());
}

- (void)testCanInsertIsYes {
    assertThatBool([self.sut canInsert], isTrue());
}

#pragma mark - insertData 

- (void)testInsertDataCallsDelegate {
    [self.sut insertData];
    
    [verifyCount(self.mockDelegate, times(1)) insertDataInsertCellViewModel:self.sut];
}

@end
