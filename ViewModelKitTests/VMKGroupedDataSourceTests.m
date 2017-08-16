//
//  VMKGroupedDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 19/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKChangeSet.h"
#import "VMKGroupedDataSource+Private.h"

@interface VMKGroupedDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKGroupedDataSource *sut;
@property (nonatomic, strong) VMKDataSource<VMKGroupedDataSourceType> *mockDataSource;

@property (nonatomic, strong) VMKDataSource *mockDataSourceKey1;
@property (nonatomic, strong) VMKDataSource *mockDataSourceKey2;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@property (nonatomic, strong) VMKMultiRowDataSource *mockRowDataSource;
@end

@implementation VMKGroupedDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.mockDataSource = mockObjectAndProtocol([VMKDataSource class], @protocol(VMKGroupedDataSourceType));
    self.sut = [[VMKGroupedDataSource alloc] initWithDataSource:self.mockDataSource];
    
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockDataSourceKey1 = mock([VMKDataSource class]);
    self.mockDataSourceKey2 = mock([VMKDataSource class]);
    
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"one", @"two"]];
    [given([self.mockDataSource dataSourceForGroupedKey:@"one"]) willReturn:self.mockDataSourceKey1];
    [given([self.mockDataSource dataSourceForGroupedKey:@"two"]) willReturn:self.mockDataSourceKey2];
    
    self.mockRowDataSource = mock([VMKMultiRowDataSource class]);
}

- (void)tearDown {
    self.mockDataSource = nil;
    self.mockDataSourceKey1 = nil;
    self.mockDataSourceKey2 = nil;
    self.mockDelegate = nil;
    self.mockRowDataSource = nil;
    
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsDataSourceToMockDataSource {
    assertThat(self.sut.dataSource, is(self.mockDataSource));
}

- (void)testInitSetsDelegateOfDataSourceToSut {
    [(VMKDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:self.sut];
}

- (void)testSutSetsDelegateToMockDelegate {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

#pragma mark - groupedKeys

- (void)testGroupedKeysIsProvidedByDataSource {
    assertThat(self.sut.groupedKeys, containsIn(@[@"one", @"two"]));
}

- (void)testGroupedKeysDoesNotChangeAfterFirstCall {
    NSMutableArray *firstCall = self.sut.groupedKeys;
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"three", @"four", @"five"]];
    
    assertThat(self.sut.groupedKeys, is(firstCall));
}

#pragma mark - rowDataSource

- (void)testRowDataSourceIsNotNil {
    assertThat(self.sut.rowDataSource, notNilValue());
}

- (void)testRowDataSourceCalledTwiceReturnsSameObject {
    VMKMultiRowDataSource *rowDS = self.sut.rowDataSource;
    assertThat(self.sut.rowDataSource, is(rowDS));
}

- (void)testRowDataSourceCallsdataSourceForGroupedKeyFromDataSource {
    (void)self.sut.rowDataSource;
    
    [verifyCount(self.mockDataSource, times(1)) dataSourceForGroupedKey:@"one"];
    [verifyCount(self.mockDataSource, times(1)) dataSourceForGroupedKey:@"two"];
    [verifyCount(self.mockDataSource, never()) dataSourceForGroupedKey:anything()];
}

#pragma mark - dataSource:didUpdateChangeSet:

- (void)testDataSourceDidUpdateChangeSetWithDataSourceKeysCallsDelegate {
    VMKChangeSet *mockChangeSet = mock([VMKChangeSet class]);
    
    [self.sut dataSource:self.mockDataSourceKey1 didUpdateChangeSet:mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:mockChangeSet];
}

- (void)testDataSourceDidUpdateChangeSetWithDataSourceDoesNotCallDelegate {
    VMKChangeSet *mockChangeSet = mock([VMKChangeSet class]);
    
    [self.sut dataSource:self.mockDataSource didUpdateChangeSet:mockChangeSet];
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut didUpdateChangeSet:mockChangeSet];
    [NSObject cancelPreviousPerformRequestsWithTarget:self.sut];
}

- (void)testDoUpdateRearrangeKeys {
    self.sut.rowDataSource = self.mockRowDataSource;
    (void)self.sut.groupedKeys;
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"two", @"one"]];
    [given([self.mockRowDataSource dataSourceAtIndex:0]) willReturn:self.mockDataSourceKey1];
    
    [self.sut doUpdate];
    
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:0];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey1 atIndex:1];
    assertThat(self.sut.groupedKeys, containsIn(@[ @"two", @"one" ]));
}

- (void)testDoUpdateDeleteKeys {
    self.sut.rowDataSource = self.mockRowDataSource;
    (void)self.sut.groupedKeys;
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"one"]];
    
    [self.sut doUpdate];
    
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:1];
    assertThat(self.sut.groupedKeys, containsIn(@[ @"one" ]));
}

- (void)testDoUpdateInsertedKeys {
    self.sut.rowDataSource = self.mockRowDataSource;
    (void)self.sut.groupedKeys;
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"one", @"two", @"three" ]];
    [given([self.mockDataSource dataSourceForGroupedKey:@"three"]) willReturn:self.mockDataSourceKey2];
    
    [self.sut doUpdate];
    
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey2 atIndex:2];
    assertThat(self.sut.groupedKeys, containsIn(@[ @"one", @"two", @"three" ]));
}

- (void)testDoUpdateDeletedInsertedKeys {
    self.sut.rowDataSource = self.mockRowDataSource;
    (void)self.sut.groupedKeys;
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"one", @"three" ]];
    [given([self.mockDataSource dataSourceForGroupedKey:@"three"]) willReturn:self.mockDataSourceKey2];
    
    [self.sut doUpdate];
    
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:1];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey2 atIndex:1];
    assertThat(self.sut.groupedKeys, containsIn(@[ @"one", @"three" ]));
}

- (void)testDoUpdateDeletedInsertedRearrangeKeys {
    self.sut.rowDataSource = self.mockRowDataSource;
    self.sut.groupedKeys = [@[@"1", @"2", @"3", @"4"] mutableCopy];
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"4", @"new1", @"3", @"new2", @"1" ]];
    [given([self.mockDataSource dataSourceForGroupedKey:@"new1"]) willReturn:self.mockDataSourceKey1];
    [given([self.mockDataSource dataSourceForGroupedKey:@"new2"]) willReturn:self.mockDataSourceKey2];
    [given([self.mockRowDataSource dataSourceAtIndex:0]) willReturn:self.mockDataSourceKey1];
    [given([self.mockRowDataSource dataSourceAtIndex:4]) willReturn:self.mockDataSourceKey2];

    
    [self.sut doUpdate];
    
    // delete data source
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:1];
    // inserted data sources
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey1 atIndex:1];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey2 atIndex:3];
    // rearrange data sources
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:0];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey1 atIndex:4];
    
    assertThat(self.sut.groupedKeys, containsIn(@[ @"4", @"new1", @"3", @"new2", @"1" ]));
}

- (void)testDoUpdateDeletedInsertedRearrangeKeysCase2 {
    self.sut.rowDataSource = self.mockRowDataSource;
    self.sut.groupedKeys = [@[@"1", @"2", @"3", @"4", @"5" ] mutableCopy];
    [given([self.mockDataSource groupedKeys]) willReturn:@[@"3", @"new1", @"4", @"new2", @"1" ]];
    [given([self.mockDataSource dataSourceForGroupedKey:@"new1"]) willReturn:self.mockDataSourceKey1];
    [given([self.mockDataSource dataSourceForGroupedKey:@"new2"]) willReturn:self.mockDataSourceKey2];
    [given([self.mockRowDataSource dataSourceAtIndex:0]) willReturn:self.mockDataSourceKey1];
    [given([self.mockRowDataSource dataSourceAtIndex:2]) willReturn:self.mockDataSourceKey2];
    
    
    [self.sut doUpdate];
    
    // delete data source
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:1];
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:3];
    // inserted data sources
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey1 atIndex:1];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey2 atIndex:3];
    // rearrange data sources
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:0];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey1 atIndex:4];
    [verifyCount(self.mockRowDataSource, times(1)) removeDataSourceAtIndex:2];
    [verifyCount(self.mockRowDataSource, times(1)) insertDataSource:self.mockDataSourceKey2 atIndex:0];
    
    assertThat(self.sut.groupedKeys, containsIn(@[ @"3", @"new1", @"4", @"new2", @"1" ]));
}

#pragma mark - sections

- (void)testSectionsReturnsOne {
    assertThatInteger([self.sut sections], equalToInteger(1));
}

- (void)testSectionsDoesNotCallDataSource {
    [self.sut sections];

    [verifyCount(self.mockDataSource, never()) sections];
}

#pragma mark - rowsInSection:

- (void)testRowsInSectionZeroReturnsFive {
    [given([self.mockDataSourceKey1 rowsInSection:0]) willReturnInteger:3];
    [given([self.mockDataSourceKey2 rowsInSection:0]) willReturnInteger:2];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(5));
}

- (void)testRowsInSectionZeroDoesNotCallDataSource {
    [self.sut rowsInSection:0];

    [verifyCount(self.mockDataSource, never()) rowsInSection:0];
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPathCallsProviderKeys {
    [given([self.mockDataSourceKey1 rowsInSection:0]) willReturnInteger:3];
    [given([self.mockDataSourceKey2 rowsInSection:0]) willReturnInteger:2];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    VMKViewModel *mockViewModel = mock([VMKViewModel class]);
    [given([self.mockDataSourceKey1 viewModelAtIndexPath:indexPath]) willReturn:mockViewModel];
    
    assertThat([self.sut viewModelAtIndexPath:indexPath], is(mockViewModel));
}

- (void)testViewModelAtIndexPathDoesNotCallDataSource {
    [given([self.mockDataSourceKey1 rowsInSection:0]) willReturnInteger:3];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.sut viewModelAtIndexPath:indexPath];
    
    [verifyCount(self.mockDataSource, never()) viewModelAtIndexPath:indexPath];
}

#pragma mark - headerViewModelAtSection:

- (void)testHeaderViewModelAtSectionCallsDataSource {
    [self.sut headerViewModelAtSection:0];
    
    [verifyCount(self.mockDataSource, times(1)) headerViewModelAtSection:0];
}

- (void)testHeaderViewModelAtSectionReturnsNilIfNotImplementedByDataSource {
    self.mockDataSource = mockProtocolWithoutOptionals(@protocol(VMKDataSourceType));
    VMKGroupedDataSource *sut = [[VMKGroupedDataSource alloc] initWithDataSource:self.mockDataSource];
    
    assertThat([sut headerViewModelAtSection:0], nilValue());
}

#pragma mark - sectionIndexTitles:

- (void)testSectionIndexTitlesCallsDataSource {
    [self.sut sectionIndexTitles];
    
    [verifyCount(self.mockDataSource, times(1)) sectionIndexTitles];
}

- (void)testSectionIndexTitlesReturnsNilIfNotImplementedByDataSource {
    self.mockDataSource = mockProtocolWithoutOptionals(@protocol(VMKDataSourceType));
    VMKGroupedDataSource *sut = [[VMKGroupedDataSource alloc] initWithDataSource:self.mockDataSource];
    
    assertThat([sut sectionIndexTitles], nilValue());
}

#pragma mark - sectionForSectionIndexTitle:atIndex:

- (void)testSectionForSectionIndexTitleAtIndexCallsDataSource {
    [self.sut sectionForSectionIndexTitle:@"test" atIndex:2];
    
    [verifyCount(self.mockDataSource, times(1)) sectionForSectionIndexTitle:@"test" atIndex:2];
}

- (void)testSectionForSectionIndexTitleAtIndexReturnsNilIfNotImplementedByDataSource {
    self.mockDataSource = mockProtocolWithoutOptionals(@protocol(VMKDataSourceType));
    VMKGroupedDataSource *sut = [[VMKGroupedDataSource alloc] initWithDataSource:self.mockDataSource];
    
    assertThatInteger([sut sectionForSectionIndexTitle:@"test" atIndex:0], equalToInteger(-1));
}

#pragma mark - titleForHeaderInSection:

- (void)testTitleForHeaderInSectionCallsDataSource {
    [self.sut titleForHeaderInSection:0];
    
    [verifyCount(self.mockDataSource, times(1)) titleForHeaderInSection:0];
}

- (void)testTitleForHeaderInSectionReturnsNilIfNotImplementedByDataSource {
    self.mockDataSource = mockProtocolWithoutOptionals(@protocol(VMKDataSourceType));
    VMKGroupedDataSource *sut = [[VMKGroupedDataSource alloc] initWithDataSource:self.mockDataSource];
    
    assertThat([sut titleForHeaderInSection:0], nilValue());
}

#pragma mark - titleForFooterInSection:

- (void)testTitleForFooterInSectionCallsDataSource {
    [self.sut titleForFooterInSection:0];
    
    [verifyCount(self.mockDataSource, times(1)) titleForFooterInSection:0];
}

- (void)testTitleForFooterInSectionReturnsNilIfNotImplementedByDataSource {
    self.mockDataSource = mockProtocolWithoutOptionals(@protocol(VMKDataSourceType));
    VMKGroupedDataSource *sut = [[VMKGroupedDataSource alloc] initWithDataSource:self.mockDataSource];
    
    assertThat([sut titleForFooterInSection:0], nilValue());
}

#pragma mark - setEditing:

- (void)testSetEditingCallsSetEditingOnDataSource {
    [self.sut setEditing:YES];
    
    [verifyCount(self.mockDataSource, times(1)) setEditing:YES];
}

- (void)testSetEditingTwiceCallsOnylOnceSetEditingOnDataSource {
    [self.sut setEditing:YES];

    [self.sut setEditing:YES];
    
    [verifyCount(self.mockDataSource, times(1)) setEditing:YES];
}

- (void)testSetEditingCallsSetEditingOnDataSourceKeys {
    [self.sut setEditing:YES];
    
    [verifyCount(self.mockDataSourceKey1, times(1)) setEditing:YES];
    [verifyCount(self.mockDataSourceKey2, times(1)) setEditing:YES];
}

@end
