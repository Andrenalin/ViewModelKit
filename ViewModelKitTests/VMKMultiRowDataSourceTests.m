//
//  VMKMultiRowDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 28/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKMultiRowDataSource.h"
#import "VMKMultipleDataSource+Private.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"

@interface VMKMultiRowDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKMultiRowDataSource *sut;
@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) VMKDataSource *mockAddDataSource;
@property (nonatomic, strong) VMKDataSource *mockSecondDataSource;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@end

@implementation VMKMultiRowDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.mockDataSource = mock([VMKDataSource class]);
    self.mockSecondDataSource = mock([VMKDataSource class]);
    
    self.sut = [[VMKMultiRowDataSource alloc] initWithDataSources:@[ self.mockDataSource, self.mockSecondDataSource] ];
    
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockAddDataSource = mock([VMKDataSource class]);
    
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:3];
    [given([self.mockSecondDataSource rowsInSection:0]) willReturnInteger:5];
    [given([self.mockAddDataSource rowsInSection:0]) willReturnInteger:2];
}

- (void)tearDown {
    self.mockDataSource = nil;
    self.mockSecondDataSource = nil;
    self.mockAddDataSource = nil;
    self.mockDelegate = nil;

    self.sut = nil;
    [super tearDown];
}

#pragma mark - helper

- (VMKChangeSet *)changeSetFromDelegate {
    HCArgumentCaptor *argument = [[HCArgumentCaptor alloc] init];
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:(id)argument];
    return argument.value;
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
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

- (void)testAddDataSourceCallsDelegateWithChangeSet {
    [self.sut addDataSource:self.mockAddDataSource];

    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testAddDataSourceCallsDelegateWithChangeSetHasChanges {
    [self.sut addDataSource:self.mockAddDataSource];
    
    VMKChangeSet *changeSet = [self changeSetFromDelegate];
    
    assertThat(changeSet.history, hasCountOf(2));
    assertThat(changeSet.history[0].rowIndexPath, is([NSIndexPath indexPathForRow:8 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeRowInserted));
    assertThat(changeSet.history[1].rowIndexPath, is([NSIndexPath indexPathForRow:9 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[1].type, equalToUnsignedInteger(VMKSingleChangeTypeRowInserted));
}

#pragma mark - removeDataSource:

- (void)testRemoveDataSourceRemovesDataSource {
    [self.sut removeDataSource:self.mockDataSource];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockSecondDataSource]));
}

- (void)testRemoveDataSourceRemovesDelegateFromDataSource {
    [self.sut removeDataSource:self.mockDataSource];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:nilValue()];
}

- (void)testRemoveDataSourceCallsDelegateWithChangeSet {
    [self.sut removeDataSource:self.mockDataSource];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testRemoveDataSourceCallsDelegateWithChangeSetHasChanges {
    [self.sut removeDataSource:self.mockDataSource];
    
    VMKChangeSet *changeSet = [self changeSetFromDelegate];
    
    assertThat(changeSet.history, hasCountOf(3));
    assertThat(changeSet.history[0].rowIndexPath, is([NSIndexPath indexPathForRow:0 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeRowDeleted));
    assertThat(changeSet.history[1].rowIndexPath, is([NSIndexPath indexPathForRow:1 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[1].type, equalToUnsignedInteger(VMKSingleChangeTypeRowDeleted));
    assertThat(changeSet.history[2].rowIndexPath, is([NSIndexPath indexPathForRow:2 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[2].type, equalToUnsignedInteger(VMKSingleChangeTypeRowDeleted));
}

#pragma mark - insertDataSource:atIndex:

- (void)testInsertDataSourceAtIndexZeroAddsDataSource {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:0];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockAddDataSource, self.mockDataSource, self.mockSecondDataSource]));
}

- (void)testInsertDataSourceAtIndexZeroSetsDelegate {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:0];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockAddDataSource, times(1)) setDelegate:self.sut];
}

- (void)testInsertDataSourceAtIndexZeroCallsDelegateWithChangeSet {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:0];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:anything()];
}


- (void)testInsertDataSourceAtIndexZeroCallsDelegateWithChangeSetHasChanges {
    [self.sut insertDataSource:self.mockAddDataSource atIndex:0];
    
    VMKChangeSet *changeSet = [self changeSetFromDelegate];
    
    assertThat(changeSet.history, hasCountOf(2));
    assertThat(changeSet.history[0].rowIndexPath, is([NSIndexPath indexPathForRow:0 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeRowInserted));
    assertThat(changeSet.history[1].rowIndexPath, is([NSIndexPath indexPathForRow:1 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[1].type, equalToUnsignedInteger(VMKSingleChangeTypeRowInserted));
}

#pragma mark - removeDataSourceAtIndex:

- (void)testRemoveDataSourceAtIndexZero {
    [self.sut removeDataSourceAtIndex:0];
    
    assertThat(self.sut.dataSources, containsIn(@[self.mockSecondDataSource]));
}

- (void)testRemoveDataSourceAtIndexZeroRemovesDelegateFromDataSource {
    [self.sut removeDataSourceAtIndex:0];
    
    [(VMKMultipleDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:nilValue()];
}

- (void)testRemoveDataSourceAtIndexOneCallsDelegateWithChangeSet {
    [self.sut removeDataSourceAtIndex:1];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testRemoveDataSourceAtIndexCallsDelegateWithChangeSetHasChanges {
    [self.sut removeDataSourceAtIndex:1];
    
    VMKChangeSet *changeSet = [self changeSetFromDelegate];
    
    assertThat(changeSet.history, hasCountOf(5));
    assertThat(changeSet.history[0].rowIndexPath, is([NSIndexPath indexPathForRow:3 inSection:0]));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeRowDeleted));
}

#pragma mark - sections

- (void)testSectionsReturnsOne {
    assertThatInteger([self.sut sections], equalToInteger(1));
}

#pragma mark - rowsInSection

- (void)testRowsInSectionZeroReturnsZero {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:0];
    [given([self.mockSecondDataSource rowsInSection:0]) willReturnInteger:0];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(0));
}

- (void)testRowsInSectionZeroReturnsOne {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:1];
    [given([self.mockSecondDataSource rowsInSection:0]) willReturnInteger:0];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(1));
}

- (void)testRowsInSectionZeroReturnsTwo {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:1];
    [given([self.mockSecondDataSource rowsInSection:0]) willReturnInteger:1];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(2));
}

- (void)testRowsInSectionOneThrowsAnException {
    XCTAssertThrows([self.sut rowsInSection:1]);
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPathWithSectionOneThrows {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:1];
    
    XCTAssertThrows([self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
}

- (void)testViewModelAtIndexPathFirstCallsViewModelAtIndexPathOnDataSource {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:1];
    [given([self.mockSecondDataSource rowsInSection:0]) willReturnInteger:1];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.sut viewModelAtIndexPath:firstIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) viewModelAtIndexPath:firstIndexPath];
    [verifyCount(self.mockSecondDataSource, never()) viewModelAtIndexPath:anything()];
}

- (void)testViewModelAtIndexPathSecondCallsViewModelAtIndexPathOnSecondDataSource {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:1];
    [given([self.mockSecondDataSource rowsInSection:0]) willReturnInteger:1];
    
    NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.sut viewModelAtIndexPath:secondIndexPath];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [verifyCount(self.mockDataSource, never()) viewModelAtIndexPath:anything()];
    [verifyCount(self.mockSecondDataSource, times(1)) viewModelAtIndexPath:firstIndexPath];
}

@end
