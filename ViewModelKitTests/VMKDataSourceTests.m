//
//  VMKDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 23/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKDataSource.h"

@interface VMKDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKDataSource *sut;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@end

@implementation VMKDataSourceTests

- (void)setUp {
    [super setUp];

    self.sut = [[VMKDataSource alloc] init];
    
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
}

- (void)tearDown {
    self.mockIndexPath = nil;
    self.mockDelegate = nil;

    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsDelegate {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

#pragma mark - sections

- (void)testSectionsReturnsZero {
    assertThatInteger([self.sut sections], equalToInteger(0));
}

#pragma mark - rowsInSection

- (void)testRowsInSectionsReturnsZero {
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(0));
}

#pragma mark - viewModelAtIndexPath

- (void)testViewModelAtIndexPathReturnsNil {
    assertThat([self.sut viewModelAtIndexPath:self.mockIndexPath], nilValue());
}

@end
