//
//  VMKMultiSectionDataSource.m
//  ViewModelKit
//
//  Created by Andre Trettin on 08/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKMultiSectionDataSource.h"
#import "VMKMultipleDataSource+Private.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"

@interface VMKMultiSectionDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKMultiSectionDataSource *sut;
@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) VMKDataSource *mockAddDataSource;
@property (nonatomic, strong) VMKDataSource *mockSecondDataSource;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@property (nonatomic, strong) VMKViewModel *mockViewModel;
@end


@implementation VMKMultiSectionDataSourceTests

- (void)setUp {
    [super setUp];

    self.mockDataSource = mockObjectAndProtocol([VMKDataSource class], @protocol(VMKDataSourceType));
    self.mockSecondDataSource = mockObjectAndProtocol([VMKDataSource class], @protocol(VMKDataSourceType));
    
    self.sut = [[VMKMultiSectionDataSource alloc] initWithDataSources:@[ self.mockDataSource, self.mockSecondDataSource] ];
    
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockAddDataSource = mock([VMKDataSource class]);
    
    [self setUpDataSource:self.mockDataSource withSections:3];
    [self setUpDataSource:self.mockSecondDataSource withSections:5];
    [self setUpDataSource:self.mockAddDataSource withSections:2];
    self.mockViewModel = mock([VMKViewModel class]);
}

- (void)tearDown {
    self.mockDataSource = nil;
    self.mockSecondDataSource = nil;
    self.mockAddDataSource = nil;
    self.mockDelegate = nil;
    self.mockViewModel = nil;
    
    self.sut = nil;
    [super tearDown];
}

#pragma mark - helper

- (void)setUpDataSource:(VMKDataSource *)dataSource withSections:(NSInteger)sections {
    [given([dataSource sections]) willReturnInteger:sections];
    for (NSInteger section = 0; section < sections; ++section) {
        [given([dataSource rowsInSection:section]) willReturnInteger:section + 1];
    }
}

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
    assertThatUnsignedInteger(changeSet.history[0].section, equalToUnsignedInteger(8));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionInserted));
    assertThatUnsignedInteger(changeSet.history[1].section, equalToUnsignedInteger(9));
    assertThatUnsignedInteger(changeSet.history[1].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionInserted));
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
    assertThatUnsignedInteger(changeSet.history[0].section, equalToUnsignedInteger(0));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionDeleted));
    assertThatUnsignedInteger(changeSet.history[1].section, equalToUnsignedInteger(1));
    assertThatUnsignedInteger(changeSet.history[1].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionDeleted));
    assertThatUnsignedInteger(changeSet.history[2].section, equalToUnsignedInteger(2));
    assertThatUnsignedInteger(changeSet.history[2].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionDeleted));
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
    assertThatUnsignedInteger(changeSet.history[0].section, equalToUnsignedInteger(0));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionInserted));
    assertThatUnsignedInteger(changeSet.history[1].section, equalToUnsignedInteger(1));
    assertThatUnsignedInteger(changeSet.history[1].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionInserted));
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
    assertThatUnsignedInteger(changeSet.history[0].section, equalToUnsignedInteger(3));
    assertThatUnsignedInteger(changeSet.history[0].type, equalToUnsignedInteger(VMKSingleChangeTypeSectionDeleted));
}

#pragma mark - sections

- (void)testSectionsReturnsEight {
    assertThatInteger([self.sut sections], equalToInteger(8));
}

- (void)testSectionsReturnsTen {
    [self.sut addDataSource:self.mockAddDataSource];
    
    assertThatInteger([self.sut sections], equalToInteger(10));
}

#pragma mark - rowsInSection

- (void)testRowsInSectionZeroIfSectionIszero {
    self.sut.dataSources = [@[] mutableCopy];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(0));
}

- (void)testRowsInSectionZeroReturnsZero {
    [given([self.mockDataSource rowsInSection:0]) willReturnInteger:0];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(0));
}

- (void)testRowsInSectionOneReturnsTwo {
    assertThatInteger([self.sut rowsInSection:1], equalToInteger(2));
}

- (void)testRowsInSectionSevenReturnsFive {
    assertThatInteger([self.sut rowsInSection:7], equalToInteger(5));
}

- (void)testRowsInSectionOneThrowsAnException {
    XCTAssertThrows([self.sut rowsInSection:9]);
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPathWithSectionEightThrows {
    XCTAssertThrows([self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8]]);
}

- (void)testViewModelAtIndexPathFirstCallsViewModelAtIndexPathOnDataSource {
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.sut viewModelAtIndexPath:firstIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) viewModelAtIndexPath:firstIndexPath];
    [verifyCount(self.mockSecondDataSource, never()) viewModelAtIndexPath:anything()];
}

- (void)testViewModelAtIndexPathSecondCallsViewModelAtIndexPathOnSecondDataSource {
    NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    NSIndexPath *mappedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.sut viewModelAtIndexPath:secondIndexPath];
    
    [verifyCount(self.mockDataSource, never()) viewModelAtIndexPath:anything()];
    [verifyCount(self.mockSecondDataSource, times(1)) viewModelAtIndexPath:mappedIndexPath];
}

#pragma mark - headerViewModelAtSection:

- (void)testHeaderViewModelAtSectionZeroReturnsNilIfSectionsAreZero {
    self.sut.dataSources = [@[] mutableCopy];
    
    assertThat([self.sut headerViewModelAtSection:0], nilValue());
}

- (void)testHeaderViewModelAtSectionEightThrows {
    XCTAssertThrows([self.sut headerViewModelAtSection:8]);
}

- (void)testHeaderViewModelAtSectionZeroReturnsNil {
    assertThat([self.sut headerViewModelAtSection:0], nilValue());
}

- (void)testHeaderViewModelAtSectionSevenReturnsViewModel {
    [given([self.mockSecondDataSource headerViewModelAtSection:4]) willReturn:self.mockViewModel];
    assertThat([self.sut headerViewModelAtSection:7], is(self.mockViewModel));
}

#pragma mark - sectionIndexTitles:

- (void)testSectionIndexTitlesReturnsNil {
    assertThat([self.sut sectionIndexTitles], nilValue());
}

- (void)testSectionIndexTitlesReturnsEmptyList {
    [given([self.mockDataSource sectionIndexTitles]) willReturn:@[]];

    assertThat([self.sut sectionIndexTitles], hasCountOf(0));
}

- (void)testSectionIndexTitlesReturnsAnEntry {
    [given([self.mockDataSource sectionIndexTitles]) willReturn:@[ @"Test1" ]];
    
    assertThat([self.sut sectionIndexTitles], containsIn(@[ @"Test1" ]));
}

- (void)testSectionIndexTitlesReturnsMultipleEntries {
    [given([self.mockDataSource sectionIndexTitles]) willReturn:@[ @"1" ]];
    [given([self.mockSecondDataSource sectionIndexTitles]) willReturn:@[ @"2", @"3" ]];
    
    assertThat([self.sut sectionIndexTitles], containsIn(@[ @"1", @"2", @"3" ]));
}

#pragma mark - titleForHeaderInSection:

- (void)testTitleForHeaderInSectionZeroReturnsNilIfSectionsAreZero {
    self.sut.dataSources = [@[] mutableCopy];
    
    assertThat([self.sut titleForHeaderInSection:0], nilValue());
}

- (void)testTitleForHeaderInSectionEightThrows {
    XCTAssertThrows([self.sut titleForHeaderInSection:8]);
}

- (void)testTitleForHeaderInSectionZeroReturnsNil {
    assertThat([self.sut titleForHeaderInSection:0], nilValue());
}

- (void)testTitleForHeaderInSectionOneReturnsTitle {
    [given([self.mockDataSource titleForHeaderInSection:1]) willReturn:@"MyTestTitle"];
    
    assertThat([self.sut titleForHeaderInSection:1], is(@"MyTestTitle"));
}

- (void)testTitleForHeaderInSectionThreeReturnsTitle {
    [given([self.mockSecondDataSource titleForHeaderInSection:0]) willReturn:@"Second"];
    
    assertThat([self.sut titleForHeaderInSection:3], is(@"Second"));
}

#pragma mark - titleForFooterInSection:

- (void)testTitleForFooterInSectionZeroReturnsNilIfSectionsAreZero {
    self.sut.dataSources = [@[] mutableCopy];
    
    assertThat([self.sut titleForFooterInSection:0], nilValue());
}

- (void)testTitleForFooterInSectionEightThrows {
    XCTAssertThrows([self.sut titleForFooterInSection:8]);
}

- (void)testTitleForFooterInSectionZeroReturnsNil {
    assertThat([self.sut titleForFooterInSection:0], nilValue());
}

- (void)testTitleForFooterInSectionOneReturnsTitle {
    [given([self.mockDataSource titleForFooterInSection:1]) willReturn:@"MyTestTitle"];
    
    assertThat([self.sut titleForFooterInSection:1], is(@"MyTestTitle"));
}

- (void)testTitleForFooterInSectionThreeReturnsTitle {
    [given([self.mockSecondDataSource titleForFooterInSection:0]) willReturn:@"Second"];
    
    assertThat([self.sut titleForFooterInSection:3], is(@"Second"));
}

#pragma mark - sectionForSectionIndexTitle:atIndex:

- (void)testSectionForSectionIndexTitleAtIndexReturnMinusOne {
    self.sut.dataSources = [@[] mutableCopy];

    assertThatInteger([self.sut sectionForSectionIndexTitle:@"Nothing" atIndex:1], equalToInteger(-1));
}

- (void)testSectionForSectionIndexTitleAtIndexReturnZero {
    assertThatInteger([self.sut sectionForSectionIndexTitle:@"Nothing" atIndex:1], equalToInteger(0));
}

@end
