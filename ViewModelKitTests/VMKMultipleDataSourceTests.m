//
//  VMKMultipleDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 20/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKChangeSet.h"

#import "VMKMultipleDataSource+Private.h"

@interface VMKMultipleDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKMultipleDataSource *sut;
@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) VMKDataSource *mockAddDataSource;
@property (nonatomic, strong) VMKDataSource *mockSecondDataSource;

@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@end

@implementation VMKMultipleDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.mockDataSource = mock([VMKDataSource class]);
    self.mockSecondDataSource = mock([VMKDataSource class]);

    self.sut = [[VMKMultipleDataSource alloc] initWithDataSources:@[ self.mockDataSource, self.mockSecondDataSource] ];
    
    self.mockAddDataSource = mock([VMKDataSource class]);
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
}

- (void)tearDown {
    self.mockDataSource = nil;
    self.mockSecondDataSource = nil;
    self.mockAddDataSource = nil;
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

- (void)testInitSetsDataSources {
    assertThat(self.sut.dataSources, hasItems(self.mockDataSource, self.mockSecondDataSource, nil));
}

- (void)testInitSetsDelegateToAllDataSources {
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:self.sut];
    [(VMKMultipleDataSource *)verifyCount(self.mockSecondDataSource, times(1)) setDelegate:self.sut];
}

#pragma mark - resetDataSources:

- (void)testResetDataSourcesWithEmptyArray {
    [self.sut resetDataSources:@[]];
    
    assertThat(self.sut.dataSources, hasCountOf(0));
}

#pragma mark - dataSources

- (void)testDataSourcesIsNotNil {
    VMKMultipleDataSource *sut = [[VMKMultipleDataSource alloc] initWithDataSources:nil];
    
    assertThat(sut.dataSources, notNilValue());
}

#pragma mark - sections

- (void)testSectionsReturnZero {
    assertThatInteger([self.sut sections], equalToInteger(0));
}

- (void)testRowsInSectionReturnZero {
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(0));
}

#pragma mark - childOffsetForDataSource

- (void)testChildOffsetForDataSourceReturnsZero {
    assertThatInteger([self.sut childOffsetForDataSource:self.mockDataSource], equalToInteger(0));
}

- (void)testChildOffsetForDataSourceSecondReturnsAlsoZero {
    assertThatInteger([self.sut childOffsetForDataSource:self.mockSecondDataSource], equalToInteger(0));
}

#pragma mark - mappedChildDataSourceIndexPathForIndexPath

- (void)testMappedChildDataSourceIndexPathForIndexPathReturnsNil {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    assertThat([self.sut mappedChildDataSourceIndexPathForIndexPath:indexPath], nilValue());
}

- (void)testMappedChildDataSourceIndexPathForIndexPathSecondReturnsAlsoNil {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    assertThat([self.sut mappedChildDataSourceIndexPathForIndexPath:indexPath], nilValue());
}

#pragma mark - mapChangeSet:withDataSource:

- (void)testChangeSetWithDataSourceDoesNotThrow {
    VMKChangeSet *mockChangeSet = mock([VMKChangeSet class]);
    XCTAssertNoThrow([self.sut mapChangeSet:mockChangeSet withDataSource:self.mockDataSource]);
}

#pragma mark - changeSetForDataSource:

- (void)testChangeSetForDataSourceReturnsChangeSet {
    assertThat([self.sut changeSetForDataSource:self.mockDataSource isAdded:NO], notNilValue());
}

- (void)testChangeSetForDataSourceSecondReturnsAlsoChangeSet {
    assertThat([self.sut changeSetForDataSource:self.mockSecondDataSource isAdded:YES], notNilValue());
}

#pragma mark - setEditing:

- (void)testSetEditingSetsEditingToAllDataSources {
    self.sut.editing = YES;
    
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setEditing:YES];
    [(VMKMultipleDataSource *)verifyCount(self.mockSecondDataSource, times(1)) setEditing:YES];
}

- (void)testSetEditingSetsEditingToAllDataSourcesOnlyOnceEvenItIsCalledTwice {
    self.sut.editing = YES;
    
    self.sut.editing = YES;
    
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setEditing:YES];
    [(VMKMultipleDataSource *)verifyCount(self.mockSecondDataSource, times(1)) setEditing:YES];
}

#pragma mark - dataSourceAtIndexPath:

- (void)testDataSourceAtIndexPathReturnsNil {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:56 inSection:2];

    assertThat([self.sut dataSourceAtIndexPath:indexPath], nilValue());
}

#pragma mark - addDataSource:

- (void)testAddDataSourceAddsDataSource {
    [self.sut addDataSource:self.mockAddDataSource];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockDataSource, self.mockSecondDataSource, self.mockAddDataSource]));
}

- (void)testAddDataSourceSetsDelegate {
    [self.sut addDataSource:self.mockAddDataSource];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockAddDataSource, times(1)) setDelegate:self.sut];
}

#pragma mark - insertDataSource:atIndex:

- (void)testInsertDataSourceAddsDataSourceAtIndexZero {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:0];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockAddDataSource, self.mockDataSource, self.mockSecondDataSource]));
}

- (void)testInsertDataSourceAddsDataSourceAtIndexOne {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:1];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockDataSource, self.mockAddDataSource, self.mockSecondDataSource]));
}

- (void)testInsertDataSourceAddsDataSourceAtIndexTwo {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:2];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockDataSource, self.mockSecondDataSource, self.mockAddDataSource]));
}

- (void)testInsertDataSourceAtIndexThreeThrowsAnException {
    XCTAssertThrows([self.sut insertDataSource:self.mockAddDataSource atIndex:3]);
}

- (void)testInsertDataSourceSetsDelegate {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:0];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockAddDataSource, times(1)) setDelegate:self.sut];
}

#pragma mark - removeDataSourceAtIndex:

- (void)testRemoveDataSourceAtIndexZero {
    [self.sut removeDataSourceAtIndex:0];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockSecondDataSource]));
}

- (void)testRemoveDataSourceAtIndexOne {
    [self.sut removeDataSourceAtIndex:1];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockDataSource]));
}

- (void)testRemoveDataSourceAtIndexTwoThrowsAnException {
    XCTAssertThrows([self.sut removeDataSourceAtIndex:2]);
}

- (void)testRemoveDataSourceAtIndexZeroRemovesDelegateFromDataSource {
    [self.sut removeDataSourceAtIndex:0];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:nilValue()];
}

#pragma mark - removeDataSource:

- (void)testRemoveDataSourceRemovesDataSource {
    [self.sut removeDataSource:self.mockDataSource];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockSecondDataSource]));
}

- (void)testRemoveDataSourceRemovesSecondDataSource {
    [self.sut removeDataSource:self.mockSecondDataSource];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockDataSource]));
}

- (void)testRemoveDataSourceDoesNotThrowIfDataSourceWasNotAddedBefore {
    XCTAssertNoThrow([self.sut removeDataSource:self.mockAddDataSource]);
}

- (void)testRemoveDataSourceRemovesDelegateFromDataSource {
    [self.sut removeDataSource:self.mockDataSource];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:nilValue()];
}

#pragma mark - dataSourceAtIndex:

- (void)testDataSourceAtIndexZeroReturnsDataSource {
    assertThat([self.sut dataSourceAtIndex:0], is(self.mockDataSource));
}

- (void)testDataSourceAtIndexOneReturnsSecondDataSource {
    assertThat([self.sut dataSourceAtIndex:1], is(self.mockSecondDataSource));
}

- (void)testDataSourceAtIndexTwoThrowsAnExeceptionIfNotExists  {
    XCTAssertThrows([self.sut dataSourceAtIndex:2]);
}

@end
