//
//  VMKArrayDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 30/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKArrayDataSource+Private.h"

@interface VMKArrayDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKArrayDataSource *sut;

@property (nonatomic, strong) NSArray *mockViewModels;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockViewModel1;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockViewModel2;
@end

@implementation VMKArrayDataSourceTests

- (void)setUp {
    [super setUp];

    self.mockViewModel1 = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    self.mockViewModel2 = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    self.mockViewModels = @[ self.mockViewModel1, self.mockViewModel2 ];
    
    self.sut = [[VMKArrayDataSource alloc] initWithViewModels:self.mockViewModels];
}

- (void)tearDown {
    self.mockViewModels = nil;
    self.mockViewModel1 = nil;
    self.mockViewModel2 = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsViewModels {
    assertThat(self.sut.viewModels, containsIn(@[ self.mockViewModel1, self.mockViewModel2 ]));
}

- (void)testInitWithoutViewModels {
    VMKArrayDataSource *sut = [[VMKArrayDataSource alloc] init];
    
    assertThat(sut, notNilValue());
    assertThat(sut.viewModels, nilValue());
}

#pragma mark - resetViewModels:

- (void)testResetViewModels {
    [self.sut resetViewModels:@[ self.mockViewModel2 ]];
    assertThat(self.sut.viewModels, containsIn(@[ self.mockViewModel2 ]));
}

#pragma mark - sections

- (void)testSectionsIsOne {
    assertThatInteger([self.sut sections], equalToInteger(1));
}

#pragma mark - rowsInSection:

- (void)testRowsInSectionZeroIsTwo {
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(2));
}

- (void)testRowsInSectionOneThrows {
    XCTAssertThrows([self.sut rowsInSection:1]);
}


- (void)testRowsInSectionZeroIsFromViewModel {
    self.sut.viewModels = @[self.mockViewModel1];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(1));
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPath0IsViewModel1 {
    assertThat([self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], is(self.mockViewModel1));
}

- (void)testViewModelAtIndexPath1IsViewModel2 {
    assertThat([self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]], is(self.mockViewModel2));
}

- (void)testViewModelAtIndexPathRowOutsideThrows {
    XCTAssertThrows([self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]);
}

- (void)testViewModelAtIndexPathInvalidSectionThrows {
    XCTAssertThrows([self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
}

#pragma mark - headerViewModelAtSection:

- (void)testHeaderViewModelAtSectionInvalidThrows {
    XCTAssertThrows([self.sut headerViewModelAtSection:1]);
}

- (void)testHeaderViewModelAtSectionZeroReturnHeaderViewModel {
    VMKViewModel<VMKHeaderFooterType> *mockHVM = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKHeaderFooterType));
    self.sut.headerViewModel = mockHVM;
    
    assertThat([self.sut headerViewModelAtSection:0], is(mockHVM));
}

@end
